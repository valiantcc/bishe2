package com.example.rag_flutter_server.repository

import com.example.rag_flutter_server.model.ChatSession
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.JpaSpecificationExecutor
import java.util.*

interface ChatSessionRepository : JpaRepository<ChatSession, Long>, JpaSpecificationExecutor<ChatSession> {
    fun findAllByUserId(userId: Long, sort: Sort): List<ChatSession>
    fun deleteBySessionId(sessionId: String)
    fun findBySessionId(sessionId: String): ChatSession
}