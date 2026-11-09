# 知识索引（AI 用）

> 只放说明与文件索引，不放大段内容。代码与 diff 是最终依据；本索引指向事实来源。

## 按主题
- 接口契约 → `KNOWLEDGE/contracts/{{ 主题 }}.md`；事实来源 `{{ 代码路径 }}`
- 数据模型 → `KNOWLEDGE/data-model/{{ 主题 }}.md`；事实来源 `{{ 模型路径 }}`
- 页面模式 → `KNOWLEDGE/patterns/{{ 页面类型 }}.md`；事实来源 `{{ 组件路径 }}`
- 踩坑与调试 → `KNOWLEDGE/pitfalls/{{ 主题 }}.md`

## 按变更类型
- 加字段 → `SKILLS/field-extension.md` + `KNOWLEDGE/data-model/`
- 列表页 → `SKILLS/list-page.md`
- 设计稿转代码 → `SKILLS/design-to-code.md`

## 索引维护规则
- 每条索引一行：主题 → 文档路径 → 事实来源路径
- 文档与代码不一致时，以代码为准，文档标记 `待重构` 并回写