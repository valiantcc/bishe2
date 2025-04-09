package com.example.rag_flutter_server.repository

import com.example.rag_flutter_server.model.ChatContent
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.JpaSpecificationExecutor

interface ChatContentRepository : JpaRepository<ChatContent, Int>, JpaSpecificationExecutor<ChatContent> {
    fun findAllBySessionId(sessionId: String, sort: Sort): List<ChatContent>
    fun removeAllBySessionId(sessionId: String)
}