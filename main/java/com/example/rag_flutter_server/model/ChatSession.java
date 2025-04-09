package com.example.rag_flutter_server.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "chat_sessions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChatSession {

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "name", nullable = false, length = 50)
    private String name;
    @Id
    @Column(name = "session_id", nullable = false, unique = true)
    private String sessionId;
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}
