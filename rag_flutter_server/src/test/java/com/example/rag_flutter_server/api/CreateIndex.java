package com.example.rag_flutter_server.api;

import com.aliyun.bailian20231229.models.CreateIndexResponse;
import com.aliyun.tea.TeaException;
import com.example.rag_flutter_server.util.ClientUtil;

/**
 * 创建索引
 *
 * @author hcc
 * @since 2025-03-08 15:59:55
 */
public class CreateIndex {
    public static void main(String[] args_) throws Exception {
        com.aliyun.bailian20231229.Client client = ClientUtil.createClient();
        com.aliyun.bailian20231229.models.CreateIndexRequest createIndexRequest = new com.aliyun.bailian20231229.models.CreateIndexRequest()
                .setName("测试知识库2")
                .setStructureType("unstructured")
                .setSourceType("DATA_CENTER_CATEGORY")
                .setDescription("测试描述")
                .setSinkType("BUILT_IN")
                .setCategoryIds(java.util.Arrays.asList(
                        "default"
                ));
        com.aliyun.teautil.models.RuntimeOptions runtime = new com.aliyun.teautil.models.RuntimeOptions();
        java.util.Map<String, String> headers = new java.util.HashMap<>();
        try {
            // 复制代码运行请自行打印 API 的返回值
            CreateIndexResponse indexWithOptions = client.createIndexWithOptions("llm-jpedwtvw0yimbzqm", createIndexRequest, headers, runtime);
            System.out.println("状态码:" + indexWithOptions.statusCode);
            System.out.println("响应体信息:" + indexWithOptions.body.message);
            System.out.println("响应体数据:" + indexWithOptions.body.data.id);
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
