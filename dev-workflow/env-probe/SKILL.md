---
name: env-probe
description: >
  以只读方式探测项目环境：语言/框架、版本、已集成的测试框架、包管理器、构建工具。
  在设计与实现之前运行，结果写入设计文档。不修改任何项目文件。
  不适用于：环境已由用户明确提供且无需验证的场景。
allowed-tools: Read Grep Glob Bash(scripts/detect-test-frameworks.sh)
---

# 环境探测

## 原则

**只读。** 不安装、不修改、不猜测。探测不到的项标记为“未探测到”。

## 确定性探测优先

测试框架探测由 `scripts/detect-test-frameworks.sh` 完成：
- 读取 `pom.xml` / `build.gradle` / `package.json`
- 识别 JUnit 5、Mockito、AssertJ、Spring Boot Test、Vitest、Jest、Playwright、Cypress
- 输出结构化摘要（JSON 或 Markdown 表格）
- 模型**只读取脚本输出**，不自行遍历文件猜测

## 输出

写入设计文档“环境”章节。如未集成测试框架，附版本兼容性建议并标记为“待用户确认”。