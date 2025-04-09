package com.example.rag_flutter_server.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 聊天内容dto
 *
 * @author hcc
 * @since 2025-03-06 17:27:23
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class ChatContentDto {
    private String content;
    private Boolean isUser;
}
