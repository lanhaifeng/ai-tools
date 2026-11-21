-- ============================================================
-- 迁移脚本: V{version}__{description}.sql
-- 需求: {需求名称}
-- 作者: {author}
-- 日期: {YYYY-MM-DD}
-- 说明: {一句话说明本次变更}
-- 回滚: 见文件末尾 Rollback 段（如适用）
-- ============================================================

-- ---------- DDL ----------
-- 表: {table_name}
-- 用途: {说明}
CREATE TABLE IF NOT EXISTS {table_name} (
    id            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    {column_name} {type}       NOT NULL DEFAULT {default} COMMENT '{列说明}',
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    KEY idx_{table_name}_{column} ({column})
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='{表说明}';

-- ---------- DML（如适用） ----------
-- INSERT INTO {table_name} (...) VALUES (...);

-- ---------- Rollback（如适用） ----------
-- DROP TABLE IF EXISTS {table_name};