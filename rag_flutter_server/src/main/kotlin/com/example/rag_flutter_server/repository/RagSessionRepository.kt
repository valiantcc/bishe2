package com.example.rag_flutter_server.repository

import com.example.rag_flutter_server.model.RagSession
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.JpaSpecificationExecutor

interface RagSessionRepository : JpaRepository<RagSession, Long>, JpaSpecificationExecutor<RagSession> {
    fun findByRagName(ragName: String): RagSession?
    fun findByPipelineId(pipelineId: String):RagSession?
    fun findAllByUserId(userId: Long,sort: Sort): List<RagSession>
}