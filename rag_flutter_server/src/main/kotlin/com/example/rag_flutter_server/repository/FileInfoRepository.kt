package com.example.rag_flutter_server.repository

import com.example.rag_flutter_server.model.FileInfo
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.JpaSpecificationExecutor

interface FileInfoRepository : JpaRepository<FileInfo, Int>, JpaSpecificationExecutor<FileInfo> {
    fun findByFileName(filename: String): FileInfo?
    fun deleteByFileIdAndRagId(fileId: String, ragId: Long)
    fun findAllByRagId(ragId: Long, by: Sort): List<FileInfo>
    fun findByFileId(fileId: String): FileInfo?
}