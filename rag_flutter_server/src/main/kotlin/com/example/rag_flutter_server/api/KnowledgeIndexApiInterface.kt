package com.example.rag_flutter_server.api

/**
 *知识索引Api接口
 *
 * @since 2025-03-08 15:46:15
 * @author hcc
 */
interface KnowledgeIndexApiInterface {
    /**
     * 创建索引
     * @param indexName 索引名称
     * @param description 索引描述
     * @return 索引ID
     */
    fun createIndex(indexName: String, description: String): String

    /**
     * 删除索引
     * @param indexId 索引ID
     */
    fun deleteIndex(indexId: String)

    /**
     * 向索引追加文档
     * @param indexId 索引ID
     * @param documentIds 文档ID列表(fileIds)
     */
    fun submitIndexAddDocumentsJob(indexId: String,documentIds: List<String>)

    /**
     * 从索引删除文档
     * @param indexId 索引ID
     * @param documentIds 文档ID列表(fileIds)
     */
    fun deleteIndexDocument(indexId: String,documentIds: List<String>)


}