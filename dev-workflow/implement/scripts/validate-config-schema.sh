#!/usr/bin/env bash
# validate-config-schema.sh — 校验配置文件 schema 与必备键
# 用法: validate-config-schema.sh <config-file> [schema-file]
# 支持: .properties / .yaml / .yml（基础键存在性检查）
# 退出码: 0 通过，1 发现问题，2 参数错误

set -euo pipefail
FILE="${1:?用法: validate-config-schema.sh <config-file> [schema-file]}"
[[ -f "$FILE" ]] || { echo "文件不存在: $FILE" >&2; exit 2; }

ISSUES=0

echo "校验文件: $FILE"

# 检查 1：敏感键不得硬编码明文
SENSITIVE_KEYS='password|secret|token|access[_-]?key|private[_-]?key'
if grep -Eiq "($SENSITIVE_KEYS)[[:space:]]*[:=][[:space:]]*[^[:space:]]+" "$FILE"; then
  echo "FAIL: 发现疑似敏感键硬编码明文" >&2
  grep -Ein "($SENSITIVE_KEYS)[[:space:]]*[:=]" "$FILE" | head -5 >&2
  ISSUES=$((ISSUES+1))
fi

# 检查 2：YAML 缩进一致性（基础检查：制表符）
if [[ "$FILE" =~ \.(yaml|yml)$ ]]; then
  if grep -Pq '\t' "$FILE"; then
    echo "FAIL: YAML 含制表符，可能导致解析错误" >&2
    ISSUES=$((ISSUES+1))
  fi
fi

# 检查 3：如提供 schema，必备键存在性
if [[ -n "${2:-}" && -f "${2:-}" ]]; then
  echo "使用 schema: $2"
  while IFS= read -r key; do
    [[ -z "$key" || "$key" =~ ^# ]] && continue
    if ! grep -q "$key" "$FILE"; then
      echo "FAIL: 缺少必备配置键: $key" >&2
      ISSUES=$((ISSUES+1))
    fi
  done < "$2"
fi

[[ $ISSUES -eq 0 ]] && echo "PASS: $FILE"
exit $(( ISSUES > 0 ? 1 : 0 ))