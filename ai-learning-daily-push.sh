#!/bin/bash

# AI 学习计划每日推送脚本（含试题）
# 每天推送当天的学习内容 + 试题

# 计算今天是第几天（从 2026-03-06 开始为第 1 天）
START_DATE="2026-03-06"
TODAY=$(date +%Y-%m-%d)

# 计算天数差
START_SEC=$(date -d "$START_DATE" +%s 2>/dev/null || echo 0)
TODAY_SEC=$(date -d "$TODAY" +%s)
DAY_NUM=$(( (TODAY_SEC - START_SEC) / 86400 + 1 ))

# 检查是否在学习周期内（1-160 天）
if [ $DAY_NUM -lt 1 ] || [ $DAY_NUM -gt 160 ]; then
    echo "不在学习周期内，第 $DAY_NUM 天"
    exit 0
fi

# 生成试题（根据天数）
generate_quiz() {
    local day=$1
    
    # 阶段 1：第 1-10 天（Python）
    if [ $day -le 10 ]; then
        case $day in
            1) echo "📝 **今日测试（3 题）**：

1. Python 中定义变量时，不需要声明什么？
   A. 变量名  B. 数据类型  C. 初始值  D. 作用域

2. 以下哪个是 Python 的正确赋值语法？
   A. var x = 5  B. int x = 5  C. x = 5  D. let x = 5

3. Python 中输出内容用什么函数？
   A. console.log()  B. print()  C. echo  D. System.out.println()

👉 直接回复答案（如：1.B 2.C 3.B）" ;;
            2) echo "📝 **今日测试（3 题）**：

1. Python 中条件判断用什么关键字？
   A. when  B. if  C. case  D. switch

2. 以下哪个是正确的 if 语句语法？
   A. if (x > 5)  B. if x > 5 then  C. if x > 5:  D. if x > 5 {}

3. Python 中等号比较用？
   A. =  B. ==  C. ===  D. equals

👉 直接回复答案（如：1.B 2.C 3.B）" ;;
            3) echo "📝 **今日测试（3 题）**：

1. Python 中定义函数用什么关键字？
   A. function  B. def  C. func  D. define

2. 函数参数默认值在哪里指定？
   A. 函数名后  B. 函数体内  C. 返回值后  D. 不能指定

3. 导入模块用什么关键字？
   A. include  B. require  C. import  D. using

👉 直接回复答案（如：1.B 2.A 3.C）" ;;
            *) echo "📝 **今日测试（3 题）**：
（Python 基础练习）

1-3 题略（根据当天内容生成）

👉 直接回复答案" ;;
        esac
    # 阶段 1：第 11-40 天（机器学习）
    elif [ $day -le 40 ]; then
        echo "📝 **今日测试（3 题）**：
（机器学习相关）

1. 线性回归用于什么类型的问题？
   A. 分类  B. 回归  C. 聚类  D. 降维

2. 过拟合是指模型在什么上表现好？
   A. 训练集  B. 测试集  C. 验证集  D. 新数据

3. 哪个不是机器学习算法？
   A. 决策树  B. SVM  C. Python  D. KMeans

👉 直接回复答案（如：1.B 2.A 3.C）"
    # 阶段 2-4
    else
        echo "📝 **今日测试（3 题）**：
（根据当天学习内容生成）

👉 直接回复答案，我会判分 + 解析"
    fi
}

# 生成学习内容
generate_content() {
    local day=$1
    
    if [ $day -le 10 ]; then
        case $day in
            1) echo "📅 **今日内容**：Python 环境安装 + 基础语法
📺 **资源**：廖雪峰 Python 教程 - 基础部分
💻 **任务**：安装 Anaconda，完成基础语法练习
⏱️ **时间**：1h" ;;
            2) echo "📅 **今日内容**：Python 控制流（if/for/while）
📺 **资源**：廖雪峰 Python 教程 - 控制流
💻 **任务**：完成循环和条件判断练习
⏱️ **时间**：1h" ;;
            *) echo "📅 **今日内容**：Python 学习第 $day 天
📺 **资源**：廖雪峰 Python 教程
💻 **任务**：跟随教程学习 + 代码练习
⏱️ **时间**：1h" ;;
        esac
    elif [ $day -le 40 ]; then
        echo "📅 **今日内容**：机器学习第 $((day-10)) 天
📺 **资源**：吴恩达机器学习（B 站）
💻 **任务**：观看视频 + 代码实践
⏱️ **时间**：1h"
    else
        echo "📅 **今日内容**：AI 学习第 $day 天
📺 **资源**：根据学习计划
💻 **任务**：跟随计划学习
⏱️ **时间**：1h"
    fi
}

# 生成今日内容
CONTENT=$(generate_content $DAY_NUM)
QUIZ=$(generate_quiz $DAY_NUM)

# 推送消息
MESSAGE="📚 AI 学习第 $DAY_NUM 天 / 共 160 天
━━━━━━━━━━━━━━━━
$CONTENT

━━━━━━━━━━━━━━━━
$QUIZ
━━━━━━━━━━━━━━━━
💪 坚持就是胜利！"

# 输出消息
echo "$MESSAGE"
