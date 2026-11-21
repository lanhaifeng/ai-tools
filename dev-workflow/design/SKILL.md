---
name: design
description: >
  与用户交互，将需求转化为完整的技术制品：设计文档、SQL 脚本草稿、配置项变更清单、任务拆分。
  重心前移：尽可能在设计阶段确定实现所需的结构化输入，减少实现阶段的开放式修改。
  产出物必须经用户确认后才能进入实现。
  不适用于：用户已提供完整设计且只需执行编码的场景。
allowed-tools: Read Grep Glob Write Edit Bash(scripts/lint-sql.sh)
---

# 设计与技术制品产出

## 交互分级

- **阻塞性问题**：不回答则无法确定关键设计或 SQL/配置结构。直接提问并等待。
- **非阻塞性问题**：有安全默认值、可后补。写入设计文档“待确认列表”，用户一次性确认。

## 技术制品清单（按需裁剪，但缺省应覆盖）

| # | 制品 | 模板/脚本 | 是否可后补 |
|---|---|---|---|
| 1 | 设计文档 | `references/design-doc-template.md` | 否（门禁） |
| 2 | SQL 脚本草稿（DDL/DML/迁移） | `assets/sql-migration-template.sql` + `scripts/lint-sql.sh` | 可后补的列/索引需标注 |
| 3 | 配置项变更清单 | `assets/config-change-manifest.md` | 敏感配置必须前置确认 |
| 4 | 任务拆分 | `references/task-breakdown-template.md` | 否（门禁） |

**SQL 脚本产出要求**：DDL 包含三段式注释、字段类型、默认值、索引策略；迁移脚本遵循项目已有命名规范（如 Flyway `V{version}__{description}.sql`）；**保存前必须通过 `scripts/lint-sql.sh`**。

**配置项产出要求**：每项标注配置键、环境（dev/staging/prod）、默认值、是否敏感、变更影响范围。

## 门禁

**设计门禁**：制品清单产出且阻塞性问题回答后，交回编排层。未确认的 SQL/配置草稿不进入实现。