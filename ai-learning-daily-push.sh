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

# 生成 20 道试题
generate_quiz() {
    local day=$1
    
    # 阶段 1：第 1-10 天（Python 基础）
    if [ $day -le 10 ]; then
        cat << 'EOF'
📝 **今日测试（20 题）- Python 基础**

1. Python 中定义变量时，不需要声明什么？
   A. 变量名  B. 数据类型  C. 初始值  D. 作用域

2. 以下哪个是 Python 的正确赋值语法？
   A. var x = 5  B. int x = 5  C. x = 5  D. let x = 5

3. Python 中输出内容用什么函数？
   A. console.log()  B. print()  C. echo  D. System.out.println()

4. Python 中条件判断用什么关键字？
   A. when  B. if  C. case  D. switch

5. 以下哪个是正确的 if 语句语法？
   A. if (x > 5)  B. if x > 5 then  C. if x > 5:  D. if x > 5 {}

6. Python 中等号比较用？
   A. =  B. ==  C. ===  D. equals

7. Python 中定义函数用什么关键字？
   A. function  B. def  C. func  D. define

8. 函数参数默认值在哪里指定？
   A. 函数定义时  B. 函数体内  C. 返回值后  D. 不能指定

9. 导入模块用什么关键字？
   A. include  B. require  C. import  D. using

10. Python 中列表推导式的正确语法是？
    A. [x for x in range(10)]  B. {x for x in range(10)}  C. (x for x in range(10))  D. <x for x in range(10)>

11. Python 中注释用什么符号？
    A. //  B. /* */  C. #  D. --

12. Python 中字符串可以用什么引号？
    A. 单引号  B. 双引号  C. 三引号  D. 以上都可以

13. Python 中 range(5) 生成的数字范围是？
    A. 1-5  B. 0-5  C. 0-4  D. 1-4

14. Python 中列表的 append() 方法作用是？
    A. 删除元素  B. 添加元素到末尾  C. 排序  D. 反转列表

15. Python 中字典的键必须是？
    A. 字符串  B. 数字  C. 不可变类型  D. 任意类型

16. Python 中异常处理用什么语句？
    A. try-catch  B. try-except  C. do-catch  D. if-error

17. Python 中读取文件用什么函数？
    A. read()  B. open()  C. load()  D. file()

18. Python 中 lambda 表达式用于？
    A. 定义类  B. 定义匿名函数  C. 导入模块  D. 异常处理

19. Python 中 *args 用于？
    A. 关键字参数  B. 可变位置参数  C. 默认参数  D. 返回值

20. Python 中 __init__ 方法是？
    A. 析构函数  B. 构造函数  C. 静态方法  D. 类方法

👉 直接回复答案（如：1.B 2.C 3.B ... 20.B）
EOF
    # 阶段 1：第 11-40 天（机器学习）
    elif [ $day -le 40 ]; then
        cat << 'EOF'
📝 **今日测试（20 题）- 机器学习基础**

1. 线性回归用于什么类型的问题？
   A. 分类  B. 回归  C. 聚类  D. 降维

2. 过拟合是指模型在什么上表现好？
   A. 训练集  B. 测试集  C. 验证集  D. 新数据

3. 哪个不是机器学习算法？
   A. 决策树  B. SVM  C. Python  D. KMeans

4. 训练集和测试集的常见划分比例是？
   A. 50%:50%  B. 80%:20%  C. 10%:90%  D. 99%:1%

5. 特征工程的主要目的是？
   A. 增加数据量  B. 提高模型性能  C. 减少计算时间  D. 简化代码

6. 逻辑回归用于什么类型的问题？
   A. 回归  B. 分类  C. 聚类  D. 降维

7. 决策树的根节点是？
   A. 最深的节点  B. 最浅的节点  C. 第一个分裂节点  D. 叶子节点

8. SVM 的核心思想是？
   A. 最小化误差  B. 最大化间隔  C. 随机搜索  D. 梯度下降

9. KMeans 算法属于？
   A. 监督学习  B. 无监督学习  C. 强化学习  D. 半监督学习

10. 随机森林是由什么组成的？
    A. 单个决策树  B. 多个决策树  C. 神经网络  D. SVM

11. 梯度下降算法用于？
    A. 数据预处理  B. 优化损失函数  C. 特征选择  D. 模型评估

12. L2 正则化也称为？
    A. Lasso  B. Ridge  C. Dropout  D. Early Stopping

13. 准确率 (Accuracy) 的计算公式是？
    A. TP/(TP+FP)  B. (TP+TN)/总样本数  C. TP/(TP+FN)  D. TN/(TN+FP)

14. 精确率 (Precision) 的计算公式是？
    A. TP/(TP+FP)  B. TP/(TP+FN)  C. (TP+TN)/总样本  D. TN/(TN+FP)

15. 召回率 (Recall) 的计算公式是？
    A. TP/(TP+FP)  B. TP/(TP+FN)  C. (TP+TN)/总样本  D. TN/(TN+FP)

16. 交叉验证的主要作用是？
    A. 增加数据  B. 评估模型泛化能力  C. 减少计算  D. 加速训练

17. PCA 降维算法的核心是？
    A. 最大化方差  B. 最小化方差  C. 随机投影  D. 线性回归

18. 以下哪个不是激活函数？
    A. ReLU  B. Sigmoid  C. Softmax  D. MSE

19. 学习率过大可能导致？
    A. 收敛过快  B. 不收敛  C. 过拟合  D. 欠拟合

20. 早停法 (Early Stopping) 用于防止？
    A. 欠拟合  B. 过拟合  C. 数据泄露  D. 特征缺失

👉 直接回复答案（如：1.B 2.A 3.C ... 20.B）
EOF
    # 阶段 2-4
    else
        cat << 'EOF'
📝 **今日测试（20 题）- 综合练习**

（根据学习进度生成深度学习、项目实践相关题目）

👉 直接回复答案，我会判分 + 解析
EOF
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
