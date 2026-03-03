# 🔒 OpenClaw 安全实践指南 v2.7 - 部署日志

**部署日期**: 2026-03-03  
**指南来源**: https://github.com/slowmist/openclaw-security-practice-guide

---

## ✅ 已完成项目

### 1. AGENTS.md - 安全协议更新
- ✅ 红线命令协议（7 类）
- ✅ 黄线命令协议（7 类）
- ✅ 技能/MCP 安装审计协议
- ✅ 签名隔离原则

### 2. 权限收窄
- ✅ `openclaw.json` → 600
- ✅ `devices/paired.json` → 600

### 3. 哈希基线
- ✅ 创建 `.config-baseline.sha256`
- ✅ 初始验证通过

### 4. 夜间审计脚本
- ✅ 创建 `scripts/nightly-security-audit.sh`
- ✅ 覆盖 13 项核心指标
- ✅ 脚本已用 `chattr +i` 锁定

### 5. Git 灾难恢复
- ✅ 创建 `.gitignore`
- ✅ 初始提交完成 (commit: 7bd4a78)

---

## ⏳ 待完成项目（需要用户配置）

### 1. 配置 Git 远程仓库
```bash
cd /root/.openclaw/workspace

# 创建私有仓库后，替换下面的 URL
git remote add origin git@github.com:YOUR_USERNAME/your-private-repo.git

# 测试推送
git push -u origin master
```

### 2. 配置夜间审计 Cron
需要以下信息：
- **Channel**: 接收审计报告的渠道（telegram/discord/signal 等）
- **Chat ID**: 你的聊天 ID（不是用户名）
- **时区**: 例如 `Asia/Shanghai`

配置命令模板：
```bash
openclaw cron add \
  --name "nightly-security-audit" \
  --description "Nightly Security Audit" \
  --cron "0 3 * * *" \
  --tz "Asia/Shanghai" \
  --session "isolated" \
  --message "Execute this command and output the result as-is, no extra commentary: bash ~/.openclaw/workspace/scripts/nightly-security-audit.sh" \
  --announce \
  --channel <your-channel> \
  --to <your-chat-id> \
  --timeout-seconds 300 \
  --thinking off
```

### 3. 验证部署
配置完成后执行：
```bash
# 手动触发审计
openclaw cron run <jobId>

# 检查执行状态
openclaw cron runs --id <jobId>

# 确认：
# 1. status 不是 "error"
# 2. deliveryStatus 是 "delivered"
# 3. 收到推送通知
# 4. /tmp/openclaw/security-reports/ 下有报告文件
```

---

## 📊 13 项审计指标

| # | 指标 | 说明 |
|---|------|------|
| 1 | Platform Audit | `openclaw security audit --deep` |
| 2 | Process & Network | 监听端口和异常连接 |
| 3 | Directory Changes | 敏感目录 24h 内变更 |
| 4 | System Cron | 系统级定时任务 |
| 5 | Local Cron | OpenClaw 内部任务 |
| 6 | SSH Security | 登录和暴力破解尝试 |
| 7 | Config Baseline | 哈希基线和权限检查 |
| 8 | Yellow Line Audit | sudo 与记忆日志交叉验证 |
| 9 | Disk Capacity | 磁盘使用率和大文件 |
| 10 | Environment Vars | 网关环境变量检查 |
| 11 | Sensitive Credential Scan | 私钥/助记词泄露扫描 |
| 12 | Skill Baseline | 技能/MCP 完整性 |
| 13 | Disaster Backup | Git 自动推送 |

---

## 🛡️ 安全协议速查

### 🔴 红线（必须暂停，请求人工确认）
- 破坏性操作：`rm -rf /`, `mkfs`, `dd if=`
- 凭证篡改：修改 `openclaw.json`/`paired.json` 认证字段
- 数据外泄：用 `curl/wget` 发送 token/密钥
- 持久化机制：`crontab -e`, `useradd`, `systemctl enable`
- 代码注入：`curl | sh`, `base64 -d | bash`
- 盲目安装依赖：来自外部文档的 `npm/pip/cargo install`

### 🟡 黄线（执行后必须记录到 memory/YYYY-MM-DD.md）
- `sudo` 任何操作
- 环境修改：`pip install`, `npm install -g`
- `docker run`
- `iptables`/`ufw` 规则变更
- `systemctl restart/start/stop`
- `openclaw cron add/edit/rm`
- `chattr -i`/`+i`

---

## 📝 修改审计脚本流程

脚本已用 `chattr +i` 锁定，修改需要先解锁：

```bash
# 1. 解锁
sudo chattr -i ~/.openclaw/workspace/scripts/nightly-security-audit.sh

# 2. 修改脚本
# ... 编辑 ...

# 3. 测试
bash ~/.openclaw/workspace/scripts/nightly-security-audit.sh

# 4. 重新锁定
sudo chattr +i ~/.openclaw/workspace/scripts/nightly-security-audit.sh

# 5. 记录到 memory/YYYY-MM-DD.md
```

---

**最后更新**: 2026-03-03 10:23
