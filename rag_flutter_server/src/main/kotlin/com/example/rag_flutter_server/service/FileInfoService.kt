package com.example.rag_flutter_server.service

import com.example.rag_flutter_server.dto.FileInfoListDto
import org.springframework.web.multipart.MultipartFile

/**
 *文件信息服务接口
 *
 * @since 2025-03-05 11:24:23
 * @author hcc
 */
interface FileInfoService {
    /**
     * 添加RAG文件
     * @param file 文件
     * @param pipelineId 流水线Id
     * @return 文件Id
     */
    fun addRagFile(file: MultipartFile,pipelineId :String): String
    fun deleteRagFile(fileId: String)
    fun listRagFile(pipelineId:String): List<FileInfoListDto>
}