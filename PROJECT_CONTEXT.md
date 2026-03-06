# 📚 AI 学习系统 - 项目上下文

> **最后更新**：2026-03-06 17:37  
> **存储位置**：GitHub 仓库 + 本地工作空间  
> **保证**：无论服务重启、网关修复、系统更新，所有信息都可恢复

---

## 👤 学员信息

| 项目 | 详情 |
|------|------|
| 背景 | 9 年 Java + 大数据开发经验 |
| 数学基础 | 高中水平 |
| 学习时间 | 工作日 1h/天 + 周末 4h/天 |
| 目标 | AI 工程师 |
| 总周期 | 160 天（约 5.5 个月） |
| 开始日期 | 2026-03-06（第 1 天） |

---

## 📅 160 天学习计划

### 阶段 1：Python + ML 基础（第 1-40 天）
- **第 1-10 天**：Python 速成（语法、numpy、pandas）
- **第 11-40 天**：机器学习核心（吴恩达 ML 课程）

### 阶段 2：深度学习 + PyTorch（第 41-70 天）
- **第 41-55 天**：神经网络基础（李宏毅 DL 课程）
- **第 56-70 天**：PyTorch 实战（CNN、RNN、Transformer）

### 阶段 3：项目实践（第 71-130 天）
- **第 71-90 天**：项目 1 - 大数据+AI（Spark MLlib）
- **第 91-110 天**：项目 2 - 深度学习应用（NLP/CV）
- **第 111-130 天**：项目 3 - Kaggle 竞赛

### 阶段 4：求职准备（第 131-160 天）
- **第 131-140 天**：简历包装（GitHub、技术博客）
- **第 141-155 天**：AI 面试八股
- **第 156-160 天**：模拟面试

---

## 🌐 在线系统（GitHub Pages）

### 1. 分阶段答题系统
**链接**：https://eat1bit.github.io/ai-learning/quiz.html

**功能**：
- 分阶段学习（Python 基础/机器学习/数据处理/模型评估）
- 解析不消失（手动点击下一题）
- 错题本功能
- 成绩评级

### 2. 每日 20 题考核系统
**链接**：https://eat1bit.github.io/ai-learning/daily-quiz.html

**功能**：
- 自动显示当天题目（从 2026-03-06 开始计算第几天）
- 可切换任意天数（1-160 天）
- 20 道选择题 + 自动判分
- 答案解析 + 错题本
- 当前题库：
  - 第 1-10 天：Python 基础 20 题
  - 第 11-40 天：机器学习 20 题
  - 第 41 天起：混合题

---

## 📝 题库文件

| 文件 | 位置 | 内容 |
|------|------|------|
| ai-quiz-bank.md | 本地 + GitHub | Markdown 题库（20 题） |
| quiz.html | ai-learning-web/ | 分阶段答题网页 |
| daily-quiz.html | ai-learning-web/ | 每日 20 题网页 |

---

## ⏰ 定时任务

**脚本**：`ai-learning-daily-push.sh`

**配置**：
```bash
# crontab -l
0 8 * * * /root/.openclaw/workspace/ai-learning-daily-push.sh
```

**功能**：
- 每天早上 8:00 自动推送
- 推送到飞书群
- 每日 20 道选择题

---

## 🧠 思维模型工具

### 芒格式思维决策器
**文件**：
- `munger-thinking-model.md` - 主文档
- `munger-thinking-model-prompt.md` - 提示词模板

**用途**：系统性分析和任务分解

**5 个阶段**：
1. 系统分析（组成部分 + 输入输出 + 依赖关系）
2. 风险评估（致命/严重/一般/轻微）
3. 收益分析（高/中/低投入产出比）
4. 任务分解（P0/P1/P2 优先级）
5. 投入确认

---

## 📂 文件存储位置

### 本地路径
```
/root/.openclaw/workspace/
├── ai-learning-plan.md              # 160 天学习计划
├── ai-quiz-bank.md                  # 题库（Markdown）
├── ai-learning-daily-push.sh        # 定时推送脚本
├── PROJECT_CONTEXT.md               # 本文件（项目上下文）
├── memory/
│   └── 2026-03-06.md               # 每日记忆
├── ai-learning-web/
│   ├── index.html                   # 学习系统主页
│   ├── quiz.html                    # 分阶段答题
│   ├── daily-quiz.html              # 每日 20 题
│   ├── quiz-bank.js                 # 题库数据
│   └── learning-plan.js             # 学习计划数据
└── munger-thinking-model.md         # 芒格式思维模型
```

### GitHub 仓库
- **AI 学习系统**：https://github.com/eat1bit/ai-learning
- **OpenClaw 工作空间**：https://github.com/eat1bit/openclaw-hello

---

## ✅ 待办事项

### 题库扩充
- [ ] Python 基础：200 题（10 天 × 20 题）
- [ ] 机器学习：600 题（30 天 × 20 题）
- [ ] 深度学习：600 题（30 天 × 20 题）
- [ ] 项目实践：1800 题（90 天 × 20 题）

### 功能优化
- [ ] 随机抽题功能（每天题目不同）
- [ ] 答题记录/进度追踪
- [ ] 与学习日历集成
- [ ] 答题数据统计分析

---

## 🔒 持久化保证

### 三重备份
1. **本地文件**：`/root/.openclaw/workspace/`
2. **GitHub 仓库**：自动推送，版本控制
3. **记忆文件**：`memory/YYYY-MM-DD.md`

### 恢复方法
如果系统重置或更新：
1. 从 GitHub 克隆仓库：`git clone https://github.com/eat1bit/ai-learning`
2. 读取 `PROJECT_CONTEXT.md` 恢复项目上下文
3. 读取 `memory/` 目录恢复近期记忆

---

## 📞 使用方式

### 每日学习流程
```
1. 打开每日 20 题页面
   → https://eat1bit.github.io/ai-learning/daily-quiz.html

2. 自动显示当天题目（第 X 天）

3. 完成 20 道选择题

4. 查看解析和错题

5. 继续下一天学习
```

### 向 AI 询问进度
直接问：
- "今天第几天？学什么？"
- "显示我的学习进度"
- "用芒格模型分析今天的任务"

AI 会读取 `PROJECT_CONTEXT.md` 和 `memory/` 文件回答。

---

**此文件保证永久更新和保存，所有后续工作都记录在此。**
