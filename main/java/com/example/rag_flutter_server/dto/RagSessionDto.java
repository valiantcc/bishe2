package com.example.rag_flutter_server.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * DTO for {@link com.example.rag_flutter_server.model.RagSession}
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class RagSessionDto implements Serializable {
    private Long userId;
    private String ragName;
    private String description;
}