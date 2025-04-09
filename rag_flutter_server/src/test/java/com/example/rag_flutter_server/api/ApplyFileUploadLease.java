package com.example.rag_flutter_server.api;

import com.aliyun.bailian20231229.models.ApplyFileUploadLeaseResponse;
import com.aliyun.bailian20231229.models.ApplyFileUploadLeaseResponseBody;
import com.aliyun.tea.TeaException;
import com.example.rag_flutter_server.util.ClientUtil;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.util.DigestUtils;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.util.Map;

/**
 * 应用文件上传租赁
 *
 * @author hcc
 * @since 2025-03-08 17:55:41
 */
public class ApplyFileUploadLease {
    public static void main(String[] args_) throws Exception {
        File file = new File("D:\\Project\\JAVA\\rag_flutter\\rag_flutter_server\\src\\test\\resources\\tset.txt");
        java.util.List<String> args = java.util.Arrays.asList(args_);
        com.aliyun.bailian20231229.Client client = ClientUtil.createClient();
        com.aliyun.bailian20231229.models.ApplyFileUploadLeaseRequest applyFileUploadLeaseRequest = new com.aliyun.bailian20231229.models.ApplyFileUploadLeaseRequest()
                .setFileName(file.getName())
                .setMd5(DigestUtils.md5DigestAsHex(new FileInputStream(file)))
                .setSizeInBytes(String.valueOf(file.length()));
        com.aliyun.teautil.models.RuntimeOptions runtime = new com.aliyun.teautil.models.RuntimeOptions();
        java.util.Map<String, String> headers = new java.util.HashMap<>();
        try {
            // 复制代码运行请自行打印 API 的返回值
            ApplyFileUploadLeaseResponse applyFileUploadLeaseResponse = client.applyFileUploadLeaseWithOptions("default", "llm-jpedwtvw0yimbzqm", applyFileUploadLeaseRequest, headers, runtime);
            ApplyFileUploadLeaseResponseBody.ApplyFileUploadLeaseResponseBodyData data = applyFileUploadLeaseResponse.getBody().data;
            System.out.println("租约id" + data.fileUploadLeaseId);
            System.out.println("租约参数" + data.param);
            uploadFile(file, data);
        } catch (TeaException error) {
            // 此处仅做打印展示，请谨慎对待异常处理，在工程项目中切勿直接忽略异常。
            // 错误 message
            System.out.println(error.getMessage());
            // 诊断地址
            System.out.println(error.getData().get("Recommend"));
            com.aliyun.teautil.Common.assertAsString(error.message);
        } catch (Exception _error) {
            TeaException error = new TeaException(_error.getMessage(), _error);
            // 此处仅做打印展示，请谨慎对待异常处理，在工程项目中切勿直接忽略异常。
            // 错误 message
            System.out.println(error.getMessage());
            // 诊断地址
            System.out.println(error.getData().get("Recommend"));
            com.aliyun.teautil.Common.assertAsString(error.message);
        }
    }

    public static void uploadFile(File file, ApplyFileUploadLeaseResponseBody.ApplyFileUploadLeaseResponseBodyData data) {
        HttpURLConnection connection = null;
        try {
            // 创建URL对象
            URL url = URI.create(data.param.url).toURL();
            connection = (HttpURLConnection) url.openConnection();

            // 设置请求方法用于文档上传，需与您在上一步中调用ApplyFileUploadLease接口实际返回的Data.Param中Method字段的值一致
            connection.setRequestMethod(data.param.method);

            // 允许向connection输出，因为这个连接是用于上传文档的
            connection.setDoOutput(true);
            // 解析 JSON 字符串为 Map
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, String> headers = objectMapper.convertValue(data.param.headers, new TypeReference<>() {
            });
            // 获取值
            String xBailianExtra = headers.get("X-bailian-extra");
            String contentType = headers.get("Content-Type");
            connection.setRequestProperty("X-bailian-extra", xBailianExtra);
            connection.setRequestProperty("Content-Type", contentType);

            // 读取文档并通过连接上传
            try (DataOutputStream outStream = new DataOutputStream(connection.getOutputStream());
                 FileInputStream fileInputStream = new FileInputStream(file)) {
                byte[] buffer = new byte[4096];
                int bytesRead;

                while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                    outStream.write(buffer, 0, bytesRead);
                }

                outStream.flush();
            }

            // 检查响应
            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                // 文档上传成功处理
                System.out.println("File uploaded successfully.");
            } else {
                // 文档上传失败处理
                System.out.println("Failed to upload the file. ResponseCode: " + responseCode);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }
}
