package com.example.rag_flutter_server.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "chat_contents")
public class ChatContent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "content", length = Integer.MAX_VALUE)
    private String content;

    @Column(name = "is_user")
    private Boolean isUser;

    @Column(name = "session_id", nullable = false)
    private String sessionId;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}