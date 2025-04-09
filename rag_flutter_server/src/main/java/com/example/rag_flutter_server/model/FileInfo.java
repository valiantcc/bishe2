package com.example.rag_flutter_server.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.ColumnDefault;

import java.time.Instant;
import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "file_info")
public class FileInfo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "file_id", length = Integer.MAX_VALUE)
    private String fileId;

    @Column(name = "file_name", length = Integer.MAX_VALUE)
    private String fileName;

    @Column(name = "rag_id", length = Integer.MAX_VALUE)
    private Long ragId;

    @Column(name = "created_at")
    private LocalDateTime createdAt;


}