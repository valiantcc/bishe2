package com.example.rag_flutter_server.api.impl

import com.aliyun.bailian20231229.Client
import com.aliyun.bailian20231229.models.CreateIndexRequest
import com.aliyun.bailian20231229.models.DeleteIndexDocumentRequest
import com.aliyun.bailian20231229.models.DeleteIndexRequest
import com.aliyun.bailian20231229.models.SubmitIndexAddDocumentsJobRequest
import com.aliyun.teautil.models.RuntimeOptions
import com.example.rag_flutter_server.api.KnowledgeIndexApiInterface
import com.example.rag_flutter_server.config.DashScopeProperties
import com.gewuyou.baseforge.core.extension.log
import org.springframework.stereotype.Service

/**
 *知识索引API
 *
 * @since 2025-03-08 15:46:47
 * @author hcc
 */
@Service
class KnowledgeIndexApi(
    private val client: Client,
    private val dashScopeProperties: DashScopeProperties
) : KnowledgeIndexApiInterface {
    /**
     * 创建索引
     * @param indexName 索引名称
     * @param description 索引描述
     * @return 索引ID
     */
    override fun createIndex(indexName: String, description: String): String {
        val createIndexRequest = CreateIndexRequest()
            .setName(indexName)
            .setDescription(description)
            .setStructureType("unstructured")
            .setSourceType("DATA_CENTER_CATEGORY")
            .setSinkType("BUILT_IN")
            .setCategoryIds(
                listOf(
                    "default"
                )
            )
        val createIndexResponse = client.createIndexWithOptions(
            dashScopeProperties.workspaceId,
            createIndexRequest,
            mapOf(),
            RuntimeOptions()
        )
        createIndexResponse.body?.data?.id.let {
            return it!!
        }
    }

    /**
     * 删除索引
     * @param indexId 索引ID
     */
    override fun deleteIndex(indexId: String) {
        val deleteIndexRequest = DeleteIndexRequest().setIndexId(indexId)
        client.deleteIndexWithOptions(
            dashScopeProperties.workspaceId,
            deleteIndexRequest,
            mapOf(),
            RuntimeOptions()
        )
    }

    /**
     * 向索引追加文档
     * @param indexId 索引ID
     * @param documentIds 文档ID列表(fileIds)
     */
    override fun submitIndexAddDocumentsJob(indexId: String, documentIds: List<String>) {
        val submitIndexAddDocumentsJobRequest = SubmitIndexAddDocumentsJobRequest()
            .setIndexId(indexId)
            .setDocumentIds(documentIds)
            .setSourceType("DATA_CENTER_FILE")
        val submitIndexAddDocumentsJobResponse = client.submitIndexAddDocumentsJobWithOptions(
            dashScopeProperties.workspaceId,
            submitIndexAddDocumentsJobRequest,
            mapOf(),
            RuntimeOptions()
        )
        if (submitIndexAddDocumentsJobResponse.body.success) {
            log.info("文档添加成功")
        } else {
            log.error("文档添加失败")
        }
    }

    /**
     * 从索引删除文档
     * @param indexId 索引ID
     * @param documentIds 文档ID列表(fileIds)
     */
    override fun deleteIndexDocument(indexId: String, documentIds: List<String>) {
        val deleteIndexDocumentRequest = DeleteIndexDocumentRequest()
            .setIndexId(indexId)
            .setDocumentIds(documentIds)
        val deleteIndexDocumentResponse = client.deleteIndexDocumentWithOptions(
            dashScopeProperties.workspaceId,
            deleteIndexDocumentRequest,
            mapOf(),
            RuntimeOptions()
        )
        if (deleteIndexDocumentResponse.body.success) {
            log.info("文档删除成功")
        } else {
            log.error("文档删除失败")
        }
    }
}