package com.gewuyou.baseforge.core.extension

import org.slf4j.Logger
import org.slf4j.LoggerFactory
/**
 *日志扩展类
 *
 * @since 2025-01-02 12:49:13
 * @author hcc
 */

/**
 * 日志扩展
 */
val <T : Any> T.log: Logger
    get() = LoggerFactory.getLogger(this::class.java)
