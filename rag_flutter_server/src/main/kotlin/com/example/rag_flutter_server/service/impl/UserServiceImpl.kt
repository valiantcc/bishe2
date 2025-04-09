package com.example.rag_flutter_server.service.impl

import com.example.rag_flutter_server.model.User
import com.example.rag_flutter_server.repository.UserRepository
import com.example.rag_flutter_server.service.UserService
import org.springframework.stereotype.Service
import java.time.LocalDateTime

/**
 *用户服务实现
 *
 * @since 2025-03-04 21:48:01
 * @author hcc
 */
@Service
class UserServiceImpl(
    private val userRepository: UserRepository
) : UserService {
    /**
     * 注册
     */
    override fun register(username: String, password: String): Int {
        // 先检查用户名是否存在
        val user = userRepository.findByUsername(username)
        if (user != null) {
            return -1
        }
        // 注册
        val newUser = User
            .builder()
            .username(username)
            .password(password)
            .createdAt(LocalDateTime.now())
            .build()
        userRepository.save(newUser)
        return 1
    }

    /**
     * 登录
     */
    override fun login(username: String, password: String): User? {
        // 先检查用户名是否存在
        val user = userRepository.findByUsername(username) ?: return null
        // 再检查密码是否正确
        if (user.password != password) {
            return null
        }
        return user
    }

    /**
     * 获取用户信息
     */
    override fun getUser(id: Long): User? {
        return userRepository.findById(id).orElse(null)
    }
}