# 安装所需的包
if (!require(ggplot2)) install.packages("ggplot2")

# 设置碱基
bases_x <- c("A", "C", "G", "T")  # x轴从左到右
bases_y <- rev(bases_x)           # y轴从下到上，逆序

# 模拟碱基频率（随机生成，总和为1的概率分布）
set.seed(123)  # 保证结果可重复
base_frequencies <- runif(4)
base_frequencies <- base_frequencies / sum(base_frequencies)  # 归一化，总和为1

# 打印碱基频率
base_frequencies_df <- data.frame(Base = bases_x, Frequency = base_frequencies)
print("碱基频率：")
print(base_frequencies_df)

# 随机生成替换速率矩阵 (4x4)，只生成下三角部分，并将上三角部分设为对称
substitution_rates <- matrix(0, nrow = 4, ncol = 4)
lower_triangle <- lower.tri(substitution_rates)
substitution_rates[lower_triangle] <- runif(sum(lower_triangle), min = 0, max = 1)
substitution_rates <- substitution_rates + t(substitution_rates)  # 上三角等于下三角

# 创建数据框用于ggplot
data <- expand.grid(Base1 = bases_x, Base2 = bases_y)
data$Rate <- as.vector(substitution_rates)

# 修改过滤逻辑，确保只显示下三角（考虑y轴是逆序排列的）
data <- data[as.numeric(factor(data$Base1, levels = bases_x)) > 
               as.numeric(factor(data$Base2, levels = rev(bases_x))), ]

# 绘制气泡图
library(ggplot2)
ggplot(data, aes(x = Base1, y = Base2, size = Rate)) +
  geom_point(aes(color = Rate)) +
  scale_size_continuous(range = c(1, 10)) +
  theme_minimal() +
  ggtitle("DNA碱基之间的替换速率矩阵（下三角）") +
  xlab("碱基") +
  ylab("碱基") +
  scale_color_gradient(low = "blue", high = "red") +
  scale_x_discrete(limits = bases_x) +
  scale_y_discrete(limits = bases_y)

# 输出碱基频率表
base_frequencies_df
