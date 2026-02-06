---
name: Commit message
interaction: chat
description: Generate a commit message
opts:
  alias: commit_custom
  auto_submit: true
  is_slash_cmd: true
  placement: before|false
  ignore_system_prompt: true
  stop_context_insertion: true
---

## user

You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

`````diff
${commit.diff}
`````

Surround the generated commit message in

```gitcommit
<commit message generated>
```

