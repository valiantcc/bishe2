package com.example.rag_flutter_server.api;

import com.aliyun.bailian20231229.models.DeleteIndexResponse;
import com.aliyun.tea.TeaException;
import com.example.rag_flutter_server.util.ClientUtil;

/**
 * 删除索引
 *
 * @author hcc
 * @since 2025-03-08 17:14:09
 */
public class DeleteIndex {
    public static void main(String[] args_) throws Exception {
        com.aliyun.bailian20231229.Client client = ClientUtil.createClient();
        com.aliyun.bailian20231229.models.DeleteIndexRequest deleteIndexRequest = new com.aliyun.bailian20231229.models.DeleteIndexRequest()
                .setIndexId("o04pztaidw");
        com.aliyun.teautil.models.RuntimeOptions runtime = new com.aliyun.teautil.models.RuntimeOptions();
        java.util.Map<String, String> headers = new java.util.HashMap<>();
        try {
            // 复制代码运行请自行打印 API 的返回值
            DeleteIndexResponse deleteIndexResponse = client.deleteIndexWithOptions("llm-jpedwtvw0yimbzqm", deleteIndexRequest, headers, runtime);
            System.out.println("执行结果:" + deleteIndexResponse.body.success);
        } catch (TeaException error) {
            // 此处仅做打印展示，请谨慎对待异常处理，在工程项目中切勿直接忽略异常。
            // 错误 message
            System.out.println(error.getMessage());
            com.aliyun.teautil.Common.assertAsString(error.message);
        } catch (Exception _error) {
            TeaException error = new TeaException(_error.getMessage(), _error);
            // 此处仅做打印展示，请谨慎对待异常处理，在工程项目中切勿直接忽略异常。
            // 错误 message
            System.out.println(error.getMessage());
            com.aliyun.teautil.Common.assertAsString(error.message);
        }
    }
}
