package com.example.rag_flutter_server.controller

import com.example.rag_flutter_server.dto.ChatContentAddDto
import com.example.rag_flutter_server.dto.ChatContentDto
import com.example.rag_flutter_server.dto.ChatSessionDto
import com.example.rag_flutter_server.dto.ChatSessionSaveDto
import com.example.rag_flutter_server.entity.R
import com.example.rag_flutter_server.service.ChatSessionService
import com.example.rag_flutter_server.service.UserService
import org.slf4j.LoggerFactory
import org.springframework.web.bind.annotation.*

/**
 *聊天记录控制器
 *
 * @since 2025-03-04 21:18:58
 */
@RestController
@RequestMapping("/history")
class ChatSessionController(
    private val chatSessionService: ChatSessionService,
    private val userService: UserService,
) {
    private val logger = LoggerFactory.getLogger(ChatSessionController::class.java)
    /**
     * 保存聊天记录信息
     */
    @PostMapping("/save")
    fun saveChatHistory(@RequestBody chatSessionSaveDto: ChatSessionSaveDto):R<ChatSessionDto> {
        // 查询用户是否存在
        userService.getUser(chatSessionSaveDto.userId) ?: throw IllegalArgumentException("用户不存在")
        // 保存聊天记录信息
       return R.success(chatSessionService.save(chatSessionSaveDto))
    }

    /**
     * 更新聊天记录信息
     */
    @PutMapping("/update")
    fun updateChatHistory(@RequestBody chatSessionDto: ChatSessionDto){
        chatSessionService.update(chatSessionDto)
    }

    /**
     * 获取聊天记录列表
     */
    @GetMapping("/list")
    fun getChatHistoryList(@RequestParam userId: Long): R<List<ChatSessionDto>> {
        // 查询用户是否存在
        userService.getUser(userId) ?: throw IllegalArgumentException("用户不存在")
        val chatHistoryList = chatSessionService.getChatHistoryList(userId)
        logger.info("聊天记录列表：{}", chatHistoryList)
        // 查询聊天记录列表
        return R.success(chatHistoryList)
    }

    /**
     * 获取聊天记录内容列表
     */
    @GetMapping("/{sessionId}/contents")
    fun getChatHistoryContents(@PathVariable sessionId: String): R<List<ChatContentDto>> {
        return R.success(chatSessionService.getChatHistoryContents(sessionId))
    }

    /**
     * 删除聊天记录
     */
    @DeleteMapping("/remove/{sessionId}")
    fun removeChatHistory(@PathVariable sessionId: String) {
        chatSessionService.removeChatHistory(sessionId)
    }

    /**
     * 添加聊天记录内容
     */
    @PostMapping("/content")
    fun saveChatContent(@RequestBody chatContentAddDto: ChatContentAddDto){
        chatSessionService.saveChatContent(chatContentAddDto)
    }
}