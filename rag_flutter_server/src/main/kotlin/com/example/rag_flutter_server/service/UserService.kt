package com.example.rag_flutter_server.service

import com.example.rag_flutter_server.model.User
import org.springframework.http.ResponseEntity

/**
 *用户服务
 *
 * @since 2025-03-04 21:45:46
 * @author hcc
 */
interface UserService {
    /**
     * 注册
     */
    fun register(username: String, password: String): Int

    /**
     * 登录
     */
    fun login(username: String, password: String): User?

    /**
     * 获取用户信息
     */
    fun getUser(id: Long): User?
}