#!/usr/bin/env bash
# detect-test-frameworks.sh — 确定性探测项目测试框架与构建工具
# 用法: detect-test-frameworks.sh [项目根目录]
# 输出: Markdown 摘要到 stdout；退出码 0 成功，1 部分未探测到，2 参数错误
# 原则: 只读、不安装、不修改、不猜测

set -euo pipefail
ROOT="${1:-.}"
[[ -d "$ROOT" ]] || { echo "目录不存在: $ROOT" >&2; exit 2; }

echo "## 环境探测结果"
echo ""

# ---------- 后端 ----------
echo "### 后端"
BACKEND_FOUND=0

if [[ -f "$ROOT/pom.xml" ]]; then
  BACKEND_FOUND=1
  echo "- 构建工具: Maven (pom.xml)"
  # Java 版本
  JAVA_VER=$(grep -oP '(?<=<java.version>)[^<]+' "$ROOT/pom.xml" 2>/dev/null || true)
  [[ -n "$JAVA_VER" ]] && echo "- Java 版本: $JAVA_VER" || echo "- Java 版本: 未在 pom.xml 中显式声明"
  # Spring Boot 版本
  SB_VER=$(grep -oP '(?<=<version>)[^<]+' "$ROOT/pom.xml" 2>/dev/null | head -1 || true)
  grep -q 'spring-boot' "$ROOT/pom.xml" && echo "- 框架: Spring Boot (版本需从 parent 或依赖确认)"
  # 测试框架
  TESTS=""
  grep -q 'junit-jupiter\|junit5' "$ROOT/pom.xml" && TESTS="$TESTS JUnit5"
  grep -q 'junit' "$ROOT/pom.xml" && [[ "$TESTS" != *JUnit5* ]] && TESTS="$TESTS JUnit4"
  grep -q 'mockito' "$ROOT/pom.xml" && TESTS="$TESTS Mockito"
  grep -q 'assertj' "$ROOT/pom.xml" && TESTS="$TESTS AssertJ"
  grep -q 'testcontainers' "$ROOT/pom.xml" && TESTS="$TESTS Testcontainers"
  grep -q 'spring-boot-starter-test' "$ROOT/pom.xml" && TESTS="$TESTS SpringBootTest"
  [[ -n "$TESTS" ]] && echo "- 测试框架(已集成):$TESTS" || echo "- 测试框架(已集成): 未探测到"
fi

if [[ -f "$ROOT/build.gradle" || -f "$ROOT/build.gradle.kts" ]]; then
  BACKEND_FOUND=1
  echo "- 构建工具: Gradle"
  GRADLE_FILE="$ROOT/build.gradle"; [[ -f "$ROOT/build.gradle.kts" ]] && GRADLE_FILE="$ROOT/build.gradle.kts"
  TESTS=""
  grep -q 'junit-jupiter\|junit5' "$GRADLE_FILE" && TESTS="$TESTS JUnit5"
  grep -q 'mockito' "$GRADLE_FILE" && TESTS="$TESTS Mockito"
  grep -q 'assertj' "$GRADLE_FILE" && TESTS="$TESTS AssertJ"
  [[ -n "$TESTS" ]] && echo "- 测试框架(已集成):$TESTS" || echo "- 测试框架(已集成): 未探测到"
fi

[[ $BACKEND_FOUND -eq 0 ]] && echo "- 未探测到 Java 后端工程"

# ---------- 前端 ----------
echo ""
echo "### 前端"
if [[ -f "$ROOT/package.json" ]]; then
  echo "- 包管理器: $( [[ -f "$ROOT/pnpm-lock.yaml" ]] && echo pnpm || ([[ -f "$ROOT/yarn.lock" ]] && echo yarn || echo npm) )"
  # 框架
  grep -q '"vue"' "$ROOT/package.json" && echo "- 框架: Vue"
  grep -q '"react"' "$ROOT/package.json" && echo "- 框架: React"
  grep -q '"vite"' "$ROOT/package.json" && echo "- 构建工具: Vite"
  grep -q '"webpack"' "$ROOT/package.json" && echo "- 构建工具: Webpack"
  # 测试框架
  TESTS=""
  grep -q '"vitest"' "$ROOT/package.json" && TESTS="$TESTS Vitest"
  grep -q '"jest"' "$ROOT/package.json" && TESTS="$TESTS Jest"
  grep -q '"@vue/test-utils"' "$ROOT/package.json" && TESTS="$TESTS VueTestUtils"
  grep -q '"playwright"\|"@playwright/test"' "$ROOT/package.json" && TESTS="$TESTS Playwright"
  grep -q '"cypress"' "$ROOT/package.json" && TESTS="$TESTS Cypress"
  [[ -n "$TESTS" ]] && echo "- 测试框架(已集成):$TESTS" || echo "- 测试框架(已集成): 未探测到"
else
  echo "- 未探测到 package.json"
fi

echo ""
echo "### 探测结论"
echo "- 已集成测试框架: 直接使用，不推荐替换"
echo "- 未集成: 参考 design/references 中的测试策略建议，标记为\"待用户确认\""