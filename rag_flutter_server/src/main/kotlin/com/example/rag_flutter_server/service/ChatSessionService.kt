package com.example.rag_flutter_server.service

import com.example.rag_flutter_server.dto.ChatContentAddDto
import com.example.rag_flutter_server.dto.ChatContentDto
import com.example.rag_flutter_server.dto.ChatSessionDto
import com.example.rag_flutter_server.dto.ChatSessionSaveDto

/**
 *聊天历史服务
 *
 * @since 2025-03-04 21:47:13
 * @author hcc
 */
interface ChatSessionService {
    fun save(chatSessionSaveDto: ChatSessionSaveDto):ChatSessionDto
    fun getChatHistoryList(userId: Long): List<ChatSessionDto>
    fun removeChatHistory(sessionId: String)
    fun getChatHistoryContents(sessionId: String): List<ChatContentDto>
    fun saveChatContent(chatContentAddDto: ChatContentAddDto)
    fun update(chatSessionDto: ChatSessionDto)
}