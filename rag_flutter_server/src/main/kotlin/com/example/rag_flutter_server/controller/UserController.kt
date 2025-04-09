package com.example.rag_flutter_server.controller

import com.example.rag_flutter_server.entity.R
import com.example.rag_flutter_server.model.User
import com.example.rag_flutter_server.service.UserService
import org.springframework.web.bind.annotation.*


/**
 *用户控制器
 *
 * @since 2025-03-04 21:18:05
 */
@RestController
@RequestMapping("/user")
class UserController(
    private val userService: UserService
) {
    // 注册
    @PostMapping("/register")
    fun register(@RequestBody user: User): R<String> {
        val result = userService.register(user.username, user.password)
        return if (result == 1) {
            R.success("注册成功")
        } else {
            R.fail("该用户名已被注册")
        }
    }

    // 登录
    @PostMapping("/login")
    fun login(@RequestBody user: User): R<Any> {
        val result = userService.login(user.username, user.password)
        return if (result != null) {
            R.success(result)
        } else {
            R.fail("用户名或密码错误")
        }
    }

    // 获取用户信息
    @GetMapping("/{id}")
    fun getUser(@PathVariable id: Long?): R<User> {
        return if (id == null) {
            R.fail("用户id不能为空")
        } else {
            val result = userService.getUser(id)
            if (result != null) {
                R.success(result)
            } else {
                R.fail("用户不存在")
            }
        }
    }
}