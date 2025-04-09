package com.example.rag_flutter_server.service.impl

import com.example.rag_flutter_server.dto.ChatContentAddDto
import com.example.rag_flutter_server.dto.ChatContentDto
import com.example.rag_flutter_server.dto.ChatSessionDto
import com.example.rag_flutter_server.dto.ChatSessionSaveDto
import com.example.rag_flutter_server.model.ChatContent
import com.example.rag_flutter_server.model.ChatSession
import com.example.rag_flutter_server.repository.ChatContentRepository
import com.example.rag_flutter_server.repository.ChatSessionRepository
import com.example.rag_flutter_server.service.ChatSessionService
import com.example.rag_flutter_server.util.BeanCopyUtil
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDateTime
import java.util.*

/**
 *聊天历史服务实现
 *
 * @since 2025-03-04 21:47:33
 * @author hcc
 */
@Service
class ChatSessionServiceImpl(
    private val chatSessionRepository: ChatSessionRepository,
    private val chatContentRepository: ChatContentRepository,
) : ChatSessionService {
    override fun save(chatSessionSaveDto: ChatSessionSaveDto): ChatSessionDto {
        val chatSession = chatSessionRepository.save(
            ChatSession
                .builder()
                .userId(chatSessionSaveDto.userId)
                .name(chatSessionSaveDto.name)
                .sessionId(chatSessionSaveDto.sessionId)
                .createdAt(LocalDateTime.now())
                .build()
        )
        val chatContents = chatSessionSaveDto.chatContents.map {
            val chatContent = ChatContent.builder().build()
            BeanCopyUtil.copyPropertiesWithValidation(it, chatContent, Objects::nonNull)
            chatContent.sessionId = chatSession.sessionId
            chatContent.createdAt = LocalDateTime.now()
            return@map chatContent
        }
        chatContentRepository.saveAll(chatContents)
        val chatSessionDto = ChatSessionDto()
        BeanCopyUtil.copyPropertiesWithValidation(chatSession, chatSessionDto, Objects::nonNull)
        return chatSessionDto
    }

    override fun getChatHistoryList(userId: Long): List<ChatSessionDto> {
        return chatSessionRepository.findAllByUserId(userId, Sort.by(Sort.Direction.DESC, "createdAt")).map {
            val chatContents = ChatSessionDto()
            BeanCopyUtil.copyPropertiesWithValidation(it, chatContents, Objects::nonNull)
            return@map chatContents
        }
    }

    @Transactional(rollbackFor = [Exception::class])
    override fun removeChatHistory(sessionId: String) {
        chatContentRepository.removeAllBySessionId(sessionId)
        chatSessionRepository.deleteBySessionId(sessionId)
    }

    override fun getChatHistoryContents(sessionId: String): List<ChatContentDto> {
        return chatContentRepository.findAllBySessionId(sessionId, Sort.by(Sort.Direction.ASC, "createdAt"))
            .map {
                val chatContentDto = ChatContentDto()
                BeanCopyUtil.copyPropertiesWithValidation(it, chatContentDto, Objects::nonNull)
                return@map chatContentDto
            }
    }

    override fun saveChatContent(chatContentAddDto: ChatContentAddDto) {
        val chatContent = ChatContent.builder().build()
        BeanCopyUtil.copyPropertiesWithValidation(chatContentAddDto, chatContent, Objects::nonNull)
        chatContent.createdAt = LocalDateTime.now()
        chatContentRepository.save(chatContent)
    }

    override fun update(chatSessionDto: ChatSessionDto) {
        chatSessionRepository.findBySessionId(chatSessionDto.sessionId).also {
            it.name = chatSessionDto.name
            chatSessionRepository.save(it)
        }
    }
}