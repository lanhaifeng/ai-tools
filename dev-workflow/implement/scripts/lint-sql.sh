#!/usr/bin/env bash
# lint-sql.sh — 确定性 SQL 规范检查
# 用法: lint-sql.sh <sql-file>
# 退出码: 0 通过, 1 发现问题, 2 参数错误

set -euo pipefail
FILE="${1:?用法: lint-sql.sh <sql-file>}"
[[ -f "$FILE" ]] || { echo "文件不存在: $FILE" >&2; exit 2; }

ISSUES=0

# 检查 1：禁止 SELECT *（显式列清单）
if grep -Eiq 'select[[:space:]]+\*' "$FILE"; then
  echo "FAIL: 发现 SELECT *，要求显式列清单" >&2; ISSUES=$((ISSUES+1))
fi

# 检查 2：DDL 必须有表注释
if grep -Eiq 'create[[:space:]]+table' "$FILE"; then
  if ! grep -Eiq 'comment[[:space:]]+=' "$FILE" && ! grep -Eiq 'comment[[:space:]]+on[[:space:]]+table' "$FILE"; then
    echo "FAIL: CREATE TABLE 缺少表注释" >&2; ISSUES=$((ISSUES+1))
  fi
fi

# 检查 3：迁移脚本命名规范（Flyway 风格）
BASENAME=$(basename "$FILE")
if [[ "$BASENAME" =~ ^V[0-9]+__.+\.sql$ ]] || [[ "$BASENAME" =~ ^R__.+\.sql$ ]]; then
  :
else
  echo "WARN: 迁移脚本命名未遵循 V{version}__{desc}.sql 或 R__{desc}.sql" >&2
fi

[[ $ISSUES -eq 0 ]] && echo "PASS: $FILE"
exit $(( ISSUES > 0 ? 1 : 0 ))