# basic_method ~ t-test
#在研究中最常见的行为就是对两个组进行比较。接受某种新药治疗的患者是否较使用某种现有药物的患者表现出了更大程度的改善？某种制造工艺是否较另外一种工艺制造出的不合格品更少

#在下列代码中，我们使用了一个假设方差不等的双侧检验，比较了南方（group 1）和非南方（group 0）各州的监禁概率：
library(MASS) 
t.test(Prob ~ So, data=UScrime)
# 你可以拒绝南方各州和非南方各州拥有相同监禁概率的假设（p<0.001）
# 非独立样本的t检验假定组间的差异呈正态分布。对于本例，检验的调用格式为：
t.test(y1, y2, paired=TRUE) 
#其中的y1和y2为两个非独立组的数值向量
library(MASS) 
sapply(UScrime[c("U1","U2")], function(x)(c(mean=mean(x),sd=sd(x))))
with(UScrime, t.test(U1, U2, paired=TRUE))

# 若两组数据独立，可以使用Wilcoxon秩和检验（更广为人知的名字是Mann-Whitney U检验）来评估观测是否是从相同的概率分布中抽得的（即，在一个总体中获得更高得分的概率是否比另一个总体要大）。调用格式为：wilcox.test(y ~ x, data)

#如果你使用Mann-Whitney U检验回答上一节中关于监禁率的问题，将得到这些结果：
with(UScrime, by(Prob, So, median))
wilcox.test(Prob ~ So, data=UScrime)
# 你可以再次拒绝南方各州和非南方各州监禁率相同的假设（p<0.001）
sapply(UScrime[c("U1","U2")], median)
with(UScrime, wilcox.test(U1, U2, paired=TRUE))






