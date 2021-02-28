# 高级处理

# 让我们首先考虑一个数据处理问题。一组学生参加了数学、科学和英语考试。为了给所有学生确定一个单一的成绩衡量指标，需要将这些科目的成绩组合起来。
# 另外，你还想将前20%的学生评定为A，接下来20%的学生评定为B，依次类推。最后，你希望按字母顺序对学生排序
# 数学函数
abs()
sqrt()
ceiling()
floor()
trunc()
round(x,digits = n)
signif(x,digits = n)
# cos(x),sin(x),tan(x)
# acos(x),asin(x),atan(x)
# cosh(x),sinh(x),tanh(x)
# acosh(x),asinh(x),atanh(x)
log(x,base = n)
log10(x)
log(x)
exp(x)

#统计函数
mean(x)
z <- mean(x, trim = 0.05, na.rm=TRUE) # 截尾平均数，即丢弃了最大5%和最小5%的数据和所有缺失值后的算术平均数
median(x)
sd(x)
var(x)
mad(x)
quantile(x,probs)
range(x)
sum(x)
diff(x,lag=n)
min(x)
max(x)
scale(x,centre=TRUE,scale=TRUE)
## 标准化
# 默认情况下，函数scale()对矩阵或数据框的指定列进行均值为0、标准差为1的标准化：newdata <- scale(mydata) 
# 要对每一列进行任意均值和标准差的标准化，可以使用如下的代码：newdata <- scale(mydata)*SD + M
# 其中的M是想要的均值，SD为想要的标准差newdata <- transform(mydata, myvar = scale(myvar)*10+50) 
# 此句将变量myvar标准化为均值50、标准差为10的变量

# 概率函数
# [dpqr]distribution_abbreviation() 
# d = 密度函数（density）
# p = 分布函数（distribution function）
# q = 分位数函数（quantile function）
# r = 生成随机数（随机偏差）

# Beta 分布 beta           Logistic 分布 logis 
# 二项分布 binom           多项分布 multinom 
# 柯西分布 cauchy          负二项分布 nbinom 
# （非中心）卡方分布 chisq 正态分布 norm 
# 指数分布 exp             泊松分布 pois 
# F分布 f                  Wilcoxon符号秩分布 signrank 
# Gamma分布 gamma          t分布 t 
# 几何分布 geom            均匀分布 unif 
# 超几何分布 hyper         Weibull 分布 weibull 
# 对数正态分布 lnorm       Wilcoxon 秩和分布 wilcox

#在区间[–3, 3]上绘制标准正态曲线
x <- pretty(c(-3,3), 30) 
y <- dnorm(x) 
plot(x, y, 
     type = "l", 
     xlab = "Normal Deviate", 
     ylab = "Density", 
     yaxs = "i" 
)
# 位于 z=1.96 左侧的标准正态曲线下方面积是多少？ pnorm(1.96)等于 0.975 
# 均值为 500，标准差为 100 的正态分布的 0.9 分位点值为多少？ qnorm(.9, mean=500, sd=100)等于 628.16 
# 生成 50 个均值为 50，标准差为 10 的正态随机数 rnorm(50, mean=50, sd=10)
#1. 设定随机数种子
#在每次生成伪随机数的时候，函数都会使用一个不同的种子，因此也会产生不同的结果。你可以通过函数set.seed()显式指定这个种子，让结果可以重现（reproducible）
runif(5) 
runif(5) 
set.seed(1234) 
runif(5) 
set.seed(1234) 
runif(5)
#通过手动设定种子，就可以重现你的结果了。这种能力有助于我们创建会在未来取用的，以及可与他人分享的示例。

#2. 生成多元正态数据
#在模拟研究和蒙特卡洛方法中，你经常需要获取来自给定均值向量和协方差阵的多元正态分布的数据。MASS包中的mvrnorm()函数可以让这个问题变得很容易  
#mvrnorm(n, mean, sigma) 其中n是你想要的样本大小，mean为均值向量，而sigma是方差-协方差矩阵（或相关矩阵）
library(MASS) 
options(digits=3) 
set.seed(1234)
mean <- c(230.7, 146.7, 3.6) 
sigma <- matrix(c(15360.8, 6721.2, -47.1, 
                    6721.2, 4700.9, -16.5, 
                    -47.1, -16.5, 0.3), nrow=3, ncol=3)
mydata <- mvrnorm(500, mean, sigma) 
mydata <- as.data.frame(mydata) 
names(mydata) <- c("y","x1","x2")
dim(mydata) 
head(mydata, n=10)
# 代码中设定了一个随机数种子，这样就可以在之后重现结果1。你指定了想要的均值向量和方差协方差阵1，并生成了500个伪随机观测3。为了方便，结果从矩阵转换为数据框，并为变量指定了名称。最后，你确认了拥有500个观测和3个变量，并输出了前10个观测4。请注意，由于相关矩阵同时也是协方差阵，所以其实可以直接指定相关关系的结构。
# R中的概率函数允许生成模拟数据，这些数据是从服从已知特征的概率分布中抽样而得的。近年来，依赖于模拟数据的统计方法呈指数级增长，在后续各章中会有若干示例。

#字符处理函数
nchar(x)
substr(x,start,stop)
grep(pattern,x,ignore.case = FASLE,fixed = FALSE)
sub(pattern,replacement,x,ignore.case = FALSE,fixed=FALSE)
strsplit(x,split,fixed = FALSE)
paste(...,seq='')
toupper(x)
tolower(x)

#其他实用函数
length(x)
seq(from,to,by)
rep(x,n)
cut(x,n)
pretty(x,n)
cat(...,file = 'myfile',append = FALSE)

#\n表示新行，\t为制表符，\'为单引号，\b为退格，等等。（键入?Quotes以了解更多。）例如，代码：
name <- "Bob" 
cat( "Hello", name, "\b.\n", "Isn\'t R", "\t", "GREAT?\n") 
# 可生成：Hello Bob. 
#          Isn't R GREAT?  #请注意第二行缩进了一个空格

#将函数应用于矩阵和数据框
a <- 5 
sqrt(a) 
b <- c(1.243, 5.654, 2.99) 
round(b) 
c <- matrix(runif(12), nrow=3) 
log(c) 
mean(c) 

#R中提供了一个apply()函数，可将一个任意函数“应用”到矩阵、数组、数据框的任何维度上。apply()函数的使用格式为：
apply(x, MARGIN, FUN, ...) 
#其中，x为数据对象，MARGIN是维度的下标，FUN是由你指定的函数，而...则包括了任何想传递给FUN的参数。在矩阵或数据框中，MARGIN=1表示行，MARGIN=2表示列
mydata <- matrix(rnorm(30), nrow=6) 
mydata 
apply(mydata, 1, mean)
apply(mydata, 2, mean)
apply(mydata, 2, mean, trim=0.2)
# 首先生成了一个包含正态随机数的6×5矩阵➊。然后你计算了6行的均值➋，以及5列的均值➌。最后，你计算了每列的截尾均值（在本例中，截尾均值基于中间60%的数据，最高和最低20%的值均被忽略）➍。
# FUN可为任意R函数，这也包括你自行编写的函数（参见5.4节），所以apply()是一种很强大的机制。apply()可把函数应用到数组的某个维度上，而lapply()和sapply()则可将函数应用到列表（list）上。你将在下一节中看到sapply()（它是lapply()的更好用的版本）的一个示例

#将学生的各科考试成绩组合为单一的成绩衡量指标，基于相对名次（前20%、下20%、等等）给出从A到F的评分，根据学生姓氏和名字的首字母对花名册进行排序。
options(digits=2) 
Student <- c("John Davis", "Angela Williams", "Bullwinkle Moose", 
               "David Jones", "Janice Markhammer", "Cheryl Cushing", 
               "Reuven Ytzrhak", "Greg Knox", "Joel England", 
               "Mary Rayburn") 
Math <- c(502, 600, 412, 358, 495, 512, 410, 625, 573, 522) 
Science <- c(95, 99, 80, 82, 75, 85, 80, 95, 89, 86) 
English <- c(25, 22, 18, 15, 20, 28, 15, 30, 27, 18) 
roster <- data.frame(Student, Math, Science, English, 
                       stringsAsFactors=FALSE)

z <- scale(roster[,2:4]) 
score <- apply(z, 1, mean) 
roster <- cbind(roster, score)
y <- quantile(score, c(.8,.6,.4,.2)) 
roster$grade[score >= y[1]] <- "A" 
roster$grade[score < y[1] & score >= y[2]] <- "B" 
roster$grade[score < y[2] & score >= y[3]] <- "C" 
roster$grade[score < y[3] & score >= y[4]] <- "D"
roster$grade[score < y[4]] <- "F"

name <- strsplit((roster$Student), " ")
Lastname <- sapply(name, "[", 2) 
Firstname <- sapply(name, "[", 1)
roster <- cbind(Firstname,Lastname, roster[,-1])
roster <- roster[order(Lastname,Firstname),]
roster
