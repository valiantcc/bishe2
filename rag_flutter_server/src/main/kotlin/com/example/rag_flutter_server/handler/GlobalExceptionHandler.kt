package com.example.rag_flutter_server.handler

import com.example.rag_flutter_server.entity.R
import com.example.rag_flutter_server.exception.GlobalException
import com.gewuyou.baseforge.core.extension.log
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.RestControllerAdvice

/**
 *全局异常处理程序
 *
 * @since 2025-03-08 17:07:42
 * @author hcc
 */
@RestControllerAdvice
class GlobalExceptionHandler {
    @ExceptionHandler(GlobalException::class)
    fun handleGlobalException(ex: GlobalException): R<String> {
        return R.fail(ex.getErrorMessage())
    }

    @ExceptionHandler(Exception::class)
    fun handleOtherException(ex: Exception): R<String> {
        log.error("服务器内部错误!", ex)
        return R.fail("服务器内部错误!")
    }
}