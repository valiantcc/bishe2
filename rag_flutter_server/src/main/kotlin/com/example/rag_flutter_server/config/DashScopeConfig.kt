package com.example.rag_flutter_server.config

import com.aliyun.bailian20231229.Client
import com.aliyun.teaopenapi.models.Config
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

/**
 *仪表范围配置
 *
 * @since 2025-03-07 17:53:48
 * @author hcc
 */
@Configuration
@EnableConfigurationProperties(DashScopeProperties::class)
class DashScopeConfig(
    private val dashScopeProperties: DashScopeProperties
) {
    /**
     * 创建客户端
     */
    @Bean
    fun createClient(): Client {
        return Client(
            Config()
                .also {
                    it.accessKeyId = dashScopeProperties.accessKeyId
                    it.accessKeySecret = dashScopeProperties.accessKeySecret
                    it.endpoint = dashScopeProperties.endpoint
                })
    }
}