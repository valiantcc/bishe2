package com.example.rag_flutter_server.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 结果
 *
 * @author hcc
 * @since 2025-03-04 21:59:35
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class R<T> {
    private String code;
    private String message;
    private T data;

    public static <T> R<T> success(T data) {
        return new R<>("000000", "success", data);
    }

    public static <T> R<T> success(String message, T data) {
        return new R<>("000000", message, data);
    }

    public static <T> R<T> success(String message) {
        return new R<>("000000", message, null);
    }

    public static <T> R<T> fail(String message) {
        return new R<>("999999", message, null);
    }

    public static <T> R<T> fail(String code, String message, T data) {
        return new R<>(code, message, data);
    }
}
