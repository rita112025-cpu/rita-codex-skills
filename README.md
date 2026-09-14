# rita-codex-skills

個人使用的 Codex Skills 集合，用來集中管理、備份與跨電腦安裝常用 Skills。

## 目前包含

- `security`：安全審查 Skill
- `retro`：回顧 / 復盤 Skill
- `install.ps1`：Windows 一鍵安裝腳本

## 專案結構

```text
rita-codex-skills/
├─ security/
│  └─ SKILL.md
├─ retro/
│  └─ SKILL.md
├─ install.ps1
└─ README.md
```

## 新電腦安裝

### 1. Clone Repository

在 PowerShell 執行：

```powershell
git clone https://github.com/rita112025-cpu/rita-codex-skills.git
cd rita-codex-skills
```

### 2. 安裝 Skills

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

安裝腳本會自動：

- 掃描本 Repository 中含有 `SKILL.md` 的 Skill 資料夾
- 安裝到：

```text
%USERPROFILE%\.codex\skills
```

- 若同名 Skill 已存在，會先備份舊版本
- 安裝完成後確認 `SKILL.md` 是否存在

### 3. 重新開啟 Codex

安裝完成後，請關閉目前的 Codex session，再重新開啟新的 session。

Codex 會重新執行 Skill discovery。

可用以下 Prompt 驗證：

```text
只做檢查，不修改任何檔案。

請列出目前 session 可用的 skills，
確認 security 與 retro 是否已被系統自動 discovery。
不要只檢查檔案是否存在。
```

## 更新 Skills

如果已經 Clone 過 Repository：

```powershell
cd rita-codex-skills
git pull
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

完成後重新開啟 Codex session。

## 新增自己的 Skill

在 Repository 根目錄新增資料夾，例如：

```text
my-new-skill/
└─ SKILL.md
```

`SKILL.md` 至少應包含標準 YAML frontmatter：

```markdown
---
name: my-new-skill
description: Describe when and why Codex should use this skill.
---

# My New Skill

Skill instructions here.
```

重新執行：

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

安裝腳本會自動發現新的 Skill，不需要修改 `install.ps1`。

## 備份機制

若目標位置已存在同名 Skill，安裝前會備份到類似：

```text
%USERPROFILE%\.codex\skills-backup\20260914-143000\
```

因此更新失敗時仍可手動還原舊版本。

## 注意事項

- 此 Repository 用來保存 **Codex Skill 原始碼**，不是單一專案的程式碼。
- 不要把 API Key、PAT、密碼、`.env` 或其他 Secret 提交進 Repository。
- 修改 Skill 後，建議先確認 `SKILL.md` 的 frontmatter 格式正確。
- Skill 安裝完成後，需重新開啟 Codex session 才能可靠確認是否完成 discovery。

## Repository

```text
https://github.com/rita112025-cpu/rita-codex-skills
```
