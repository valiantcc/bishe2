package com.example.rag_flutter_server.service.impl

import com.example.rag_flutter_server.api.KnowledgeIndexApiInterface
import com.example.rag_flutter_server.dto.RagSessionDto
import com.example.rag_flutter_server.dto.RagSessionListDto
import com.example.rag_flutter_server.exception.GlobalException
import com.example.rag_flutter_server.model.RagSession
import com.example.rag_flutter_server.repository.FileInfoRepository
import com.example.rag_flutter_server.repository.RagSessionRepository
import com.example.rag_flutter_server.service.RagSessionService
import org.bouncycastle.asn1.x500.style.RFC4519Style.description
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import java.time.LocalDateTime

/**
 *Rag服务实现
 *
 * @since 2025-03-04 23:25:21
 * @author hcc
 */
@Service
class RagSessionServiceImpl(
    private val ragSessionRepository: RagSessionRepository,
    private val knowledgeIndexApiInterface: KnowledgeIndexApiInterface,
    private val fileInfoRepository: FileInfoRepository
) : RagSessionService {
    override fun saveRagSession(ragSessionDto: RagSessionDto): String {
        val ragName = ragSessionDto.ragName
        // 检查ragName是否存在
        val ragSession = ragSessionRepository.findByRagName(ragName)
        if (ragSession != null) {
            throw GlobalException("该知识库已存在!")
        }
        val description = ragSessionDto.description
        // 先调用知识库接口创建索引
        val id = knowledgeIndexApiInterface.createIndex(ragName, description)
        ragSessionRepository.save(
            RagSession
                .builder()
                .userId(ragSessionDto.userId)
                .ragName(ragName)
                .description(description)
                .pipelineId(id)
                .createdAt(LocalDateTime.now())
                .build()
        )
        return id
    }

    override fun deleteRagSession(indexId: String) {
        // 先检查是否存在这个知识库
        val ragSession = ragSessionRepository.findByPipelineId(indexId) ?: throw GlobalException("该知识库不存在!")
        // 调用知识库接口删除索引
        knowledgeIndexApiInterface.deleteIndex(indexId)
        // 删除数据库记录
        ragSessionRepository.delete(ragSession)
        val fileInfos = fileInfoRepository.findAllByRagId(ragSession.id!!, Sort.by(Sort.Direction.ASC, "id"))
        // 删除所有文件
        fileInfoRepository.deleteAll(fileInfos)
    }

    override fun listRagSessionByUserId(userId: Long): List<RagSessionListDto> {
        return ragSessionRepository.findAllByUserId(userId, Sort.by(Sort.Direction.DESC, "createdAt")).map {
            RagSessionListDto
                .builder()
                .ragName(it.ragName)
                .description(it.description)
                .pipelineId(it.pipelineId)
                .build()
        }
    }
}