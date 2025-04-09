package com.example.rag_flutter_server.exception

/**
 *全局异常
 *
 * @since 2025-03-08 17:05:56
 * @author hcc
 */
class GlobalException(
    private val errorMessage: String
) : RuntimeException() {
    fun getErrorMessage(): String {
        return errorMessage
    }
}