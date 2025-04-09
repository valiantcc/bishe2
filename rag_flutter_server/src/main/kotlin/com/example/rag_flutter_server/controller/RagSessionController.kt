package com.example.rag_flutter_server.controller

import com.example.rag_flutter_server.dto.RagSessionDto
import com.example.rag_flutter_server.dto.RagSessionListDto
import com.example.rag_flutter_server.entity.R
import com.example.rag_flutter_server.exception.GlobalException
import com.example.rag_flutter_server.service.RagSessionService
import com.example.rag_flutter_server.service.UserService
import org.springframework.web.bind.annotation.*

/**
 *Rag控制器
 *
 * @since 2025-03-04 23:22:46
 */
@RestController
@RequestMapping("/rag")
class RagSessionController(
    private val ragSessionService: RagSessionService,
    private val userService: UserService
) {
    @PostMapping("/save")
    fun saveRagSession(@RequestBody ragSessionDto: RagSessionDto): R<String> {
        userService.getUser(ragSessionDto.userId) ?: throw GlobalException("用户不存在") // 校验用户是否存在
        return R.success("保存成功", ragSessionService.saveRagSession(ragSessionDto))
    }

    @DeleteMapping("/delete/{indexId}")
    fun deleteRagSession(@PathVariable indexId: String):R<String> {
        ragSessionService.deleteRagSession(indexId)
        return R.success("删除成功")
    }

    @GetMapping("/list/{userId}")
    fun listRagSessionByUserId(@PathVariable userId: Long): R<List<RagSessionListDto>> {
        return R.success("获取成功", ragSessionService.listRagSessionByUserId(userId))
    }

}