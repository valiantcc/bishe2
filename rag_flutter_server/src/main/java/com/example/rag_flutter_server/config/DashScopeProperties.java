package com.example.rag_flutter_server.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * 仪表范围属性
 *
 * @author hcc
 * @since 2025-03-08 15:39:34
 */
@Data
@ConfigurationProperties(prefix = "aliyun.dash.scope")
public class DashScopeProperties {
    /**
     * 访问密钥ID
     */
    private String accessKeyId;
    /**
     * 访问密钥
     */
    private String accessKeySecret;
    /**
     * 访问端点
     */
    private String endpoint;

    /**
     * 工作空间ID
     */
    private String workspaceId;
}
