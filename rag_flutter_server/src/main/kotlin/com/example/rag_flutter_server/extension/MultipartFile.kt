package com.example.rag_flutter_server.extension

import org.springframework.web.multipart.MultipartFile
import java.io.File
import java.io.FileOutputStream


/**
 *多部分文件
 *
 * @since 2025-03-08 21:44:41
 * @author hcc
 */

fun MultipartFile.toFile(): File {
    // 创建临时文件
    val tempFile = File.createTempFile(
        this.originalFilename?.substringBeforeLast(".") ?: "temp",
        this.originalFilename?.substringAfterLast(".") ?: ""
    )
    // 将MultipartFile写入临时文件
    this.transferTo(tempFile)
    return tempFile
}