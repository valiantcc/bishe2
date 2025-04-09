package com.example.rag_flutter_server.api.impl

import com.aliyun.bailian20231229.Client
import com.aliyun.bailian20231229.models.AddFileRequest
import com.aliyun.bailian20231229.models.ApplyFileUploadLeaseRequest
import com.aliyun.bailian20231229.models.ApplyFileUploadLeaseResponseBody
import com.aliyun.teautil.models.RuntimeOptions
import com.example.rag_flutter_server.api.DataCenterApiInterface
import com.example.rag_flutter_server.config.DashScopeProperties
import org.springframework.stereotype.Service

/**
 *数据中心API
 *
 * @since 2025-03-08 17:33:22
 * @author hcc
 */
@Service
class DataCenterApi(
    private val client: Client,
    private val dashScopeProperties: DashScopeProperties
) : DataCenterApiInterface {
    /**
     * 申请文件上传租约
     * @param fileName 文件名
     * @param md5 文件MD5值
     * @param sizeInBytes 文件大小
     * @return 申请结果数据
     */
    override fun applyFileUploadLease(
        fileName: String,
        md5: String,
        sizeInBytes: String
    ): ApplyFileUploadLeaseResponseBody.ApplyFileUploadLeaseResponseBodyData {
        val applyFileUploadLeaseRequest = ApplyFileUploadLeaseRequest()
            .setFileName(fileName)
            .setMd5(md5)
            .setSizeInBytes(sizeInBytes)
        val applyFileUploadLeaseResponse = client.applyFileUploadLease(
            "default",
            dashScopeProperties.workspaceId,
            applyFileUploadLeaseRequest
        )
        return applyFileUploadLeaseResponse.body.data
    }

    /**
     * 添加文件
     * @param leaseId 租约ID
     * @return 文件ID
     */
    override fun addFile(leaseId: String): String {
        val addFileRequest = AddFileRequest()
            .setLeaseId(leaseId)
            .setParser("DASHSCOPE_DOCMIND")
            .setCategoryId("default")
        val addFileResponse = client.addFileWithOptions(
            dashScopeProperties.workspaceId,
            addFileRequest,
            mapOf(),
            RuntimeOptions()
        )
        return addFileResponse.body.data.fileId
    }


}