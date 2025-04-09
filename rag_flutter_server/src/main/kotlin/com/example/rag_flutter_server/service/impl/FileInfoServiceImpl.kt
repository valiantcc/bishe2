package com.example.rag_flutter_server.service.impl

import com.example.rag_flutter_server.api.DataCenterApiInterface
import com.example.rag_flutter_server.api.KnowledgeIndexApiInterface
import com.example.rag_flutter_server.dto.FileInfoListDto
import com.example.rag_flutter_server.exception.GlobalException
import com.example.rag_flutter_server.extension.toFile
import com.example.rag_flutter_server.model.FileInfo
import com.example.rag_flutter_server.repository.FileInfoRepository
import com.example.rag_flutter_server.repository.RagSessionRepository
import com.example.rag_flutter_server.service.FileInfoService
import com.fasterxml.jackson.core.type.TypeReference
import com.fasterxml.jackson.databind.ObjectMapper
import com.gewuyou.baseforge.core.extension.log
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.util.DigestUtils
import org.springframework.web.multipart.MultipartFile
import java.io.DataOutputStream
import java.io.FileInputStream
import java.net.HttpURLConnection
import java.net.URI
import java.time.LocalDateTime

/**
 *文件信息服务实现
 *
 * @since 2025-03-05 11:24:57
 * @author hcc
 */
@Service
class FileInfoServiceImpl(
    private val dataCenterApiInterface: DataCenterApiInterface,
    private val ragSessionRepository: RagSessionRepository,
    private val fileInfoRepository: FileInfoRepository,
    private val knowledgeIndexApiInterface: KnowledgeIndexApiInterface
) : FileInfoService {
    /**
     * 添加RAG文件
     * @param file 文件
     * @param pipelineId RAG的pipelineId
     * @return 文件Id
     */
    override fun addRagFile(file: MultipartFile, pipelineId: String): String {
        val ragSession = ragSessionRepository.findByPipelineId(pipelineId) ?: throw GlobalException("RAG不存在")
        val ragId = ragSession.id
        // 检查文件是否已经存在
        val fileInfo = fileInfoRepository.findByFileName(file.originalFilename!!)
        if (fileInfo != null && fileInfo.ragId ==ragId) {
            throw GlobalException("文件名已存在")
        }
        // 首先获取文件租约
        val applyFileUploadResponse = dataCenterApiInterface.applyFileUploadLease(
            file.originalFilename!!,
            DigestUtils.md5DigestAsHex(file.inputStream),
            file.size.toString()
        )
        val param = applyFileUploadResponse.param
        // 然后上传文件
        uploadFile(file, param.url, param.method, param.headers)
        // 接着添加文件
        val fileId = dataCenterApiInterface.addFile(applyFileUploadResponse.fileUploadLeaseId)
        fileInfoRepository.save(
            FileInfo
                .builder()
                .fileId(fileId)
                .ragId(ragId)
                .fileName(file.originalFilename!!)
                .createdAt(LocalDateTime.now())
                .build()
        )
        knowledgeIndexApiInterface.submitIndexAddDocumentsJob(pipelineId, listOf(fileId))
        // 记录文件信息
        return fileId
    }

    @Transactional(rollbackFor = [Exception::class])
    override fun deleteRagFile(fileId: String) {
        // 获取rag的索引id
        val fileInfo = fileInfoRepository.findByFileId(fileId) ?: throw GlobalException("文件不存在")
        val ragSession = ragSessionRepository.findById(fileInfo.ragId).get()
        // 删除文件
        fileInfoRepository.deleteByFileIdAndRagId(fileId, ragSession.id)
        // 删除文件索引
        knowledgeIndexApiInterface.deleteIndexDocument(ragSession.pipelineId, listOf(fileId))
    }

    override fun listRagFile(pipelineId: String): List<FileInfoListDto> {
        val ragSession = ragSessionRepository.findByPipelineId(pipelineId) ?: throw GlobalException("RAG不存在")
        return fileInfoRepository
            .findAllByRagId(ragSession.id, Sort.by(Sort.Direction.DESC, "createdAt"))
            .map {
                FileInfoListDto(it.fileId, it.fileName)
            }
    }

    fun uploadFile(multipartFile: MultipartFile, url: String, method: String, headersObj: Any) {
        // 处理请求头
        // 解析 JSON 字符串为 Map
        val objectMapper = ObjectMapper()
        val headers: Map<String, String> =
            objectMapper.convertValue(headersObj, object : TypeReference<Map<String, String>>() {})
        val connection = (URI.create(url).toURL().openConnection() as HttpURLConnection)
            .also {
                it.requestMethod = method
                it.doOutput = true
                it.setRequestProperty("X-bailian-extra", headers["X-bailian-extra"])
                it.setRequestProperty("Content-Type", headers["Content-Type"])
            }
        val file = multipartFile.toFile()
        DataOutputStream(connection.outputStream).use { outStream ->
            FileInputStream(file).use { fileInputStream ->
                val buffer = ByteArray(4096)
                var bytesRead: Int
                while ((fileInputStream.read(buffer).also { bytesRead = it }) != -1) {
                    outStream.write(buffer, 0, bytesRead)
                }
                outStream.flush()
            }
        }
        val responseCode = connection.responseCode
        if (responseCode == HttpURLConnection.HTTP_OK) {
            log.info("上传成功")
        } else {
            log.error("上传失败，响应码：$responseCode, 响应消息：${connection.responseMessage}")
        }
    }
}