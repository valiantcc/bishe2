package com.example.rag_flutter_server.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Rag记录
 *
 * @since 2025-03-04 23:13:51
 */
@Entity
@Table(name = "rag_sessions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RagSession {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "rag_name", nullable = false, length = 50)
    private String ragName;

    @Column(name = "description")
    private String description;

    @Column(name = "pipeline_id", nullable = false, unique = true)
    private String pipelineId;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}