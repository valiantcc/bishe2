package com.example.rag_flutter_server.controller

import com.example.rag_flutter_server.dto.FileInfoListDto
import com.example.rag_flutter_server.entity.R
import com.example.rag_flutter_server.service.FileInfoService
import org.springframework.http.MediaType
import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile

/**
 *rag文件信息控制器
 *
 * @since 2025-03-05 11:25:31
 * @author hcc
 */
@RestController
@RequestMapping("/file")
class FileInfoController(
    private val fileInfoService: FileInfoService
) {
    @PostMapping("/addRagFile",consumes = [MediaType.MULTIPART_FORM_DATA_VALUE])
    fun addRagFile(
        @RequestPart("file") file: MultipartFile,
        @RequestPart("pipelineId") pipelineId: String,
    ): R<String> {
        return R.success("添加文件成功", fileInfoService.addRagFile(file, pipelineId))
    }

    @DeleteMapping("/deleteRagFile/{fileId}")
    fun deleteRagFile(@PathVariable fileId:String): R<String> {
        fileInfoService.deleteRagFile(fileId)
        return R.success("删除文件成功")
    }

    @GetMapping("/listRagFile/{pipelineId}")
    fun listRagFile(@PathVariable pipelineId:String): R<List<FileInfoListDto>> {
        return R.success("获取文件列表成功", fileInfoService.listRagFile(pipelineId))
    }
}