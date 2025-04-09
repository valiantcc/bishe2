package com.example.rag_flutter_server.api

import com.aliyun.bailian20231229.models.ApplyFileUploadLeaseResponseBody

/**
 *数据中心API接口
 *
 * @since 2025-03-08 17:33:07
 * @author hcc
 */
interface DataCenterApiInterface {
    /**
     * 申请文件上传租约
     * @param fileName 文件名
     * @param md5 文件MD5值
     * @param sizeInBytes 文件大小
     * @return 申请结果数据
     */
    fun applyFileUploadLease(fileName: String, md5: String, sizeInBytes: String): ApplyFileUploadLeaseResponseBody.ApplyFileUploadLeaseResponseBodyData

    /**
     * 添加文件
     * @param leaseId 租约ID
     * @return 文件ID
     */
    fun addFile(leaseId:String): String

}