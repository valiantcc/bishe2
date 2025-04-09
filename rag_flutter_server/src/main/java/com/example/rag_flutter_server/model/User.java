package com.example.rag_flutter_server.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 用户模型
 *
 * @since 2025-03-04 21:32:13
 */

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id; // 用户ID

    @Column(nullable = false, unique = true, length = 50)
    private String username; // 用户名（唯一）

    @Column(nullable = false)
    private String password; // 密码（建议存储哈希值）

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt; // 注册时间
}

