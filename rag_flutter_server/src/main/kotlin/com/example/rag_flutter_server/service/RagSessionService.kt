package com.example.rag_flutter_server.service

import com.example.rag_flutter_server.dto.RagSessionDto
import com.example.rag_flutter_server.dto.RagSessionListDto

/**
 *Rag服务
 *
 * @since 2025-03-04 23:25:00
 * @author hcc
 */
interface RagSessionService {
    fun saveRagSession(ragSessionDto: RagSessionDto):String
    fun deleteRagSession(indexId: String)
    fun listRagSessionByUserId(userId: Long): List<RagSessionListDto>
}