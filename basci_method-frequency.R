# 频数 basic_method-frequency
library(vcd) 
head(Arthritis)
pastecs::stat.desc(Arthritis)
## 用于创建和处理列联表的函数
# table(var1, var2, ..., varN)      使用 N 个类别型变量（因子）创建一个 N 维列联表
# xtabs(formula, data)              根据一个公式和一个矩阵或数据框创建一个 N 维列联表
# prop.table(table, margins)        依 margins 定义的边际列表将表中条目表示为分数形式
# margin.table(table, margins)      依 margins 定义的边际列表计算表中条目的和
# addmargins(table, margins)        将概述边 margins（默认是求和结果）放入表中
# ftable(table)                     创建一个紧凑的“平铺”式列联表

# 一维列联表
mytable <- with(Arthritis, table(Improved)) 
# 可以用prop.table()将这些频数转化为比例值：
prop.table(mytable) 
# 或使用prop.table()*100转化为百分比：
prop.table(mytable)*100

# 二维列联表  mytable <- table(A, B)  mytable <- xtabs(~ A + B, data=mydata)
mytable <- xtabs(~ Treatment+Improved, data=Arthritis)
margin.table(mytable, 1)
prop.table(mytable, 1)

margin.table(mytable, 2)
prop.table(mytable, 2)
prop.table(mytable)
addmargins(mytable)  # 你可以使用addmargins()函数为这些表格添加边际和
addmargins(prop.table(mytable))
addmargins(prop.table(mytable, 1), 2)
addmargins(prop.table(mytable, 2), 1)

# table()函数默认忽略缺失值（NA）。要在频数统计中将NA视为一个有效的类别，请设定参数useNA="ifany"

# 使用gmodels包中的CrossTable()函数是创建二维列联表的第三种方法
# CrossTable()函数仿照SAS中PROC FREQ或SPSS中CROSSTABS的形式生成二维列联表
# install.packages('gmodels')
library(gmodels) 
CrossTable(Arthritis$Treatment, Arthritis$Improved)

# 多维列联表
# table() 和 xtabs() 都可以基于三个或更多的类别型变量生成多维列联表。
# margin.table()、prop.table()和addmargins()函数可以自然地推广到高于二维的情况。
# 另外，ftable()函数可以以一种紧凑而吸引人的方式输出多维列联表
mytable <- xtabs(~ Treatment+Sex+Improved, data=Arthritis)
ftable(mytable)
margin.table(mytable, 1)
margin.table(mytable, 2)
margin.table(mytable, 3)
margin.table(mytable, c(1, 3))
ftable(prop.table(mytable, c(1, 2)))
ftable(addmargins(prop.table(mytable, c(1, 2)), 3))
# 如果想得到百分比而不是比例，可以将结果表格乘以100。例如：
ftable(addmargins(prop.table(mytable, c(1, 2)), 3)) * 100


## 独立性检验 ---------
# R提供了多种检验类别型变量独立性的方法。本节中描述的三种检验分别为卡方独立性检验、Fisher精确检验和Cochran-Mantel-Haenszel检验。
#1. 卡方独立性检验
#你可以使用chisq.test()函数对二维表的行变量和列变量进行卡方独立性检验
library(vcd) 
mytable <- xtabs(~Treatment+Improved, data=Arthritis) 
chisq.test(mytable)
mytable <- xtabs(~Improved+Sex, data=Arthritis) 
chisq.test(mytable)
# 在结果➊中，患者接受的治疗和改善的水平看上去存在着某种关系（p<0.01）。而患者性别和改善情况之间却不存在关系（p>0.05）➋。这里的p值表示从总体中抽取的样本行变量与列变量是相互独立的概率。由于➊的概率值很小，所以你拒绝了治疗类型和治疗结果相互独立的原假设。由于➋的概率不够小，故没有足够的理由说明治疗结果和性别之间是不独立的。代码清单7-12中产生警告信息的原因是，表中的6个单元格之一（男性－一定程度上的改善）有一个小于5的值，这可能会使卡方近似无效。

# 2. Fisher精确检验
# 可以使用fisher.test()函数进行Fisher精确检验。Fisher精确检验的原假设是：边界固定的列联表中行和列是相互独立的。其调用格式为fisher.test(mytable)，其中的mytable是一个二维列联表。示例如下：
mytable <- xtabs(~Treatment+Improved, data=Arthritis) 
fisher.test(mytable)

# 3. Cochran-Mantel-Haenszel检验
# mantelhaen.test()函数可用来进行Cochran-Mantel-Haenszel卡方检验，其原假设是，两个名义变量在第三个变量的每一层中都是条件独立的。下列代码可以检验治疗情况和改善情况在性别的每一水平下是否独立。此检验假设不存在三阶交互作用（治疗情况×改善情况×性别）。
mytable <- xtabs(~Treatment+Improved+Sex, data=Arthritis) 
mantelhaen.test(mytable) 
# 结果表明，患者接受的治疗与得到的改善在性别的每一水平下并不独立（分性别来看，用药治疗的患者较接受安慰剂的患者有了更多的改善）。


## 相关性的度量
#二维列联表的相关性度量
library(vcd) 
mytable <- xtabs(~Treatment+Improved, data=Arthritis)
assocstats(mytable)

#R可以计算多种相关系数，包括Pearson相关系数、Spearman相关系数、Kendall相关系数、偏相关系数、多分格（polychoric）相关系数和多系列（polyserial）相关系数。下面让我们依次理解这些相关系数。
#1. Pearson、Spearman和Kendall相关
#Pearson积差相关系数衡量了两个定量变量之间的线性相关程度。Spearman等级相关系数则衡量分级定序变量之间的相关程度。Kendall’s Tau相关系数也是一种非参数的等级相关度量。
#cor()函数可以计算这三种相关系数，而cov()函数可用来计算协方差,默认参数为use="everything"和method="pearson"
#协方差和相关系数
states<- state.x77[,1:6] 
cov(states)
cor(states)
cor(states, method="spearman")
#首个语句计算了方差和协方差，第二个语句则计算了Pearson积差相关系数，而第三个语句计算了Spearman等级相关系数
#请注意，在默认情况下得到的结果是一个方阵（所有变量之间两两计算相关）。你同样可以计算非方形的相关矩阵。观察以下示例：
x <- states[,c("Population", "Income", "Illiteracy", "HS Grad")] 
y <- states[,c("Life Exp", "Murder")] 
cor(x,y)

#当你对某一组变量与另外一组变量之间的关系感兴趣时，cor()函数的这种用法是非常实用的。注意，上述结果并未指明相关系数是否显著不为0（即，根据样本数据是否有足够的证据得出总体相关系数不为0的结论）。由于这个原因，你需要对相关系数进行显著性检验

#2. 偏相关
#偏相关是指在控制一个或多个定量变量时，另外两个定量变量之间的相互关系。你可以使用ggm包中的pcor()函数计算偏相关系数,pcor(u, S)
library(ggm) 
colnames(states)
#其中的u是一个数值向量，前两个数值表示要计算相关系数的变量下标，其余的数值为条件变量（即要排除影响的变量）的下标.本例中，在控制了收入、文盲率和高中毕业率的影响时，人口和谋杀率之间的相关系数为0.346

#相关性的显著性检验
#你可以使用cor.test()函数对单个的Pearson、Spearman和Kendall相关系数进行检验.简化后的使用格式为：
cor.test(x, y, alternative = , method = )
#其中的x和y为要检验相关性的变量，alternative则用来指定进行双侧检验或单侧检验（取值为"two.side"、"less"或"greater"），而method用以指定要计算的相关类型（"pearson"、"kendall" 或 "spearman" ）。 当 研 究 的 假 设 为 总 体 的 相 关 系 数 小 于 0 时，请使用alternative="less" 。在研究的假设为总体的相关系数大于 0 时，应使用alternative="greater"。在默认情况下，假设为alternative="two.side"（总体相关系数不等于0）。

#检验某种相关系数的显著性
cor.test(states[,3], states[,5])
#这段代码检验了预期寿命和谋杀率的Pearson相关系数为0的原假设。假设总体的相关度为0，则预计在一千万次中只会有少于一次的机会见到0.703这样大的样本相关度（即p=1.258e–08）。由于这种情况几乎不可能发生，所以你可以拒绝原假设，从而支持了要研究的猜想，即预期寿命和谋杀率之间的总体相关度不为0
#遗憾的是，cor.test()每次只能检验一种相关关系。但幸运的是，psych包中提供的corr.test()函数可以一次做更多事情。corr.test()函数可以为Pearson、Spearman或Kendall相关计算相关矩阵和显著性水平

#通过corr.test计算相关矩阵并进行显著性检验
library(psych) 
corr.test(states, use="complete")


# 在结束这个话题之前应当指出的是，psych包中的r.test()函数提供了多种实用的显著性
# 检验方法。此函数可用来检验：
#  某种相关系数的显著性；
#  两个独立相关系数的差异是否显著；
#  两个基于一个共享变量得到的非独立相关系数的差异是否显著；
#  两个基于完全不同的变量得到的非独立相关系数的差异是否显著。
# 参阅help(r.test)以了解详情














