# mediam_method-regression  
# 简单线性         用一个量化的解释变量预测一个量化的响应变量  
# 多项式           用一个量化的解释变量预测一个量化的响应变量，模型的关系是 n 阶多项式  
# 多层             用拥有等级结构的数据预测一个响应变量（例如学校中教室里的学生）。也被称为分层模型、嵌套模型或混合模型  
# 多元线性         用两个或多个量化的解释变量预测一个量化的响应变量  
# 多变量           用一个或多个解释变量预测多个响应变量  
# Logistic         用一个或多个解释变量预测一个类别型响应变量  
# 泊松             用一个或多个解释变量预测一个代表频数的响应变量  
# Cox 比例风险     用一个或多个解释变量预测一个事件（死亡、失败或旧病复发）发生的时间  
# 时间序列         对误差项相关的时间序列数据建模  
# 非线性           用一个或多个量化的解释变量预测一个量化的响应变量，不过模型是非线性的  
# 非参数           用一个或多个量化的解释变量预测一个量化的响应变量，模型的形式源自数据形式，不事先设定  
# 稳健             用一个或多个量化的解释变量预测一个量化的响应变量，能抵御强影响点的干扰  

# 我们主要的困难有三个：发现有趣的问题， 设计一个有用的、可以测量的响应变量，以及收集合适的数据  
# 我们的重点是普通最小二乘（OLS）回归法，包括简单线性回归、多项式回归和多元线性回归  
# OLS回归拟合模型的形式：  
#我们的目标是通过减少响应变量的真实值与预测值的差值来获得模型参数（截距项和斜率）。具体而言，即使得残差平方和最小  
#为了能够恰当地解释OLS模型的系数，数据必须满足以下统计假设。  
#  正态性 对于固定的自变量值，因变量值成正态分布。  
#  独立性 Yi值之间相互独立。  
#  线性 因变量与自变量之间为线性相关。  
#  同方差性 因变量的方差不随自变量的水平不同而变化。也可称作不变方差，但是说同方差性感觉上更犀利。  
# 如果违背了以上假设，你的统计显著性检验结果和所得的置信区间就很可能不精确了。注意，OLS回归还假定自变量是固定的且测量无误差，但在实践中通常都放松了这个假设  

# 用lm()拟合回归模型   myfit <- lm(formula, data)  
# R表达式中常用的符号  
# ~ 分隔符号，左边为响应变量，右边为解释变量。例如，要通过 x、z 和 w 预测 y，代码为 y ~ x + z + w  
# + 分隔预测变量  
# : 表示预测变量的交互项。例如，要通过 x、z 及 x 与 z 的交互项预测 y，代码为 y ~ x + z + x:z  
# * 表示所有可能交互项的简洁方式。代码 y~ x * z * w 可展开为 y ~ x + z + w + x:z + x:w + z:w + x:z:w  
# ^ 表示交互项达到某个次数。代码 y ~ (x + z + w)^2 可展开为 y ~ x + z + w + x:z + x:w + z:w  
# . 表示包含除因变量外的所有变量。例如，若一个数据框包含变量 x、y、z 和 w，代码 y ~ .可展开为 y ~ x + z + w  
# - 减号，表示从等式中移除某个变量。例如，y ~ (x + z + w)^2 – x:w 可展开为 y ~ x + z + w + x:z + z:w  
# -1 删除截距项。例如，表达式 y ~ x - 1 拟合 y 在 x 上的回归，并强制直线通过原点  
# I() 从算术的角度来解释括号中的元素。例如，y ~ x + (z + w)^2 将展开为 y ~ x + z + w + z:w。相反, 代码 y ~ x + I((z + w)^2)将展开为 y ~ x + h，h 是一个由 z 和 w 的平方和创建的新变量  
# function 可以在表达式中用的数学函数。例如，log(y) ~ x + z + w 表示通过 x、z 和 w 来预测 log(y)  

# 对拟合线性模型非常有用的其他函数  
# summary()        展示拟合模型的详细结果  
# coefficients()   列出拟合模型的模型参数（截距项和斜率）  
# confint()        提供模型参数的置信区间（默认 95%）  
# fitted()         列出拟合模型的预测值  
# residuals()      列出拟合模型的残差值  
# anova()          生成一个拟合模型的方差分析表，或者比较两个或更多拟合模型的方差分析表  
# vcov()           列出模型参数的协方差矩阵  
# AIC()            输出赤池信息统计量  
# plot()           生成评价拟合模型的诊断图  
# predict()        用拟合模型对新的数据集预测响应变量值  

#当回归模型包含一个因变量和一个自变量时，我们称为简单线性回归。当只有一个预测变量，但同时包含变量的幂（比如，X、X^2、X^3）时，我们称为多项式回归。当有不止一个预测变量时，则称为多元线性回归  

#简单线性回归  
fit <- lm(weight ~ height, data=women)   
summary(fit)  
women$weight  
fitted(fit)  
residuals(fit)  
plot(women$height,women$weight,   
     xlab="Height (in inches)",   
     ylab="Weight (in pounds)")   
abline(fit)  
# 通过输出结果，可以得到预测等式：Weight = -87.52+3.45*Height  
# R平方项（0.991）表明模型可以解释体重99.1%的方差，它也是实际和预测值之间相关系数的平方（R2=r^2ŶY）。残差标准误（1.53 lbs）则可认为是模型用身高预测体重的平均误差。F统计量检验所有的预测变量预测响应变量是否都在某个几率水平之上  
# 你可以通过添加一个二次项（即X^2）来提高回归的预测精度。  
# 如下代码可以拟合含二次项的等式：  
fit2 <- lm(weight ~ height + I(height^2), data=women)  
summary(fit2)  
plot(women$height,women$weight,   
     xlab="Height (in inches)",   
     ylab="Weight (in lbs)")   
lines(women$height,fitted(fit2))  
#新的预测等式为： Weight = 261.88 = 7.35 * Height + 0.083 * Height^2  
#在p<0.001水平下，回归系数都非常显著。模型的方差解释率已经增加到了99.9%。二次项的显著性（t=13.89，p<0.001）表明包含二次项提高了模型的拟合度。从图也可以看出曲线确实拟合得较好。  

#一般来说，n次多项式生成一个n–1个弯曲的曲线。拟合三次多项式，可用：  
fit3 <- lm(weight ~ height + I(height^2) +I(height^3), data=women)   
#虽然更高次的多项式也可用，但我发现使用比三次更高的项几乎没有必要  

#car包中的scatterplot()函数，它可以很容易、方便地绘制二元关系图  
library(car)   
scatterplot(weight ~ height, data=women,   
            spread=FALSE, smoother.args=list(lty=2), pch=19,   
            main="Women Age 30-39",   
            xlab="Height (inches)",   
            ylab="Weight (lbs.)")  
#这个功能加强的图形，既提供了身高与体重的散点图、线性拟合曲线和平滑拟合（loess）曲线，还在相应边界展示了每个变量的箱线图。spread=FALSE选项删除了残差正负均方根在平滑曲线上的展开和非对称信息。smoother.args=list(lty=2)选项设置loess拟合曲线为虚线。pch=19选项设置点为实心圆（默认为空心圆）。粗略地看一下图可知，两个变量基本对称，曲线拟合得比直线更好。  


#多元线性回归  
#以基础包中的state.x77数据集为例，我们想探究一个州的犯罪率和其他因素的关系，包括人口、文盲率、平均收入和结霜天数（温度在冰点以下的平均天数）。因为lm()函数需要一个数据框（state.x77数据集是矩阵），为了以后处理方便，你需要做如下转化：  
states <- as.data.frame(state.x77[,c("Murder", "Population",   
                                     "Illiteracy", "Income", "Frost")])  
# 多元回归分析中，第一步最好检查一下变量间的相关性。cor()函数提供了二变量之间的相关系数，car包中scatterplotMatrix()函数则会生成散点图矩阵  
states <- as.data.frame(state.x77[,c("Murder", "Population",   
                                     "Illiteracy", "Income", "Frost")])  
cor(states)  
library(car)   
scatterplotMatrix(states, spread=FALSE, smoother.args=list(lty=2),   
                  main="Scatter Plot Matrix")  

#scatterplotMatrix()函数默认在非对角线区域绘制变量间的散点图，并添加平滑和线性拟合曲线。对角线区域绘制每个变量的密度图和轴须图。  
#从图中可以看到，谋杀率是双峰的曲线，每个预测变量都一定程度上出现了偏斜。谋杀率随着人口和文盲率的增加而增加，随着收入水平和结霜天数增加而下降。同时，越冷的州府文盲率越低，收入水平越高。  
#现在使用lm()函数拟合多元线性回归模型  
states <- as.data.frame(state.x77[,c("Murder", "Population",   
                                     "Illiteracy", "Income", "Frost")])  
fit <- lm(Murder ~ Population + Illiteracy + Income + Frost,   
          data=states)  
summary(fit)  
#当预测变量不止一个时，回归系数的含义为：一个预测变量增加一个单位，其他预测变量保持不变时，因变量将要增加的数量。例如本例中，文盲率的回归系数为4.14，表示控制人口、收入和温度不变时，文盲率上升1%，谋杀率将会上升4.14%，它的系数在p<0.001的水平下显著不为0。相反，Frost的系数没有显著不为0（p=0.954），表明当控制其他变量不变时，Frost与Murder不呈线性相关。总体来看，所有的预测变量解释了各州谋杀率57%的方差。  
#以上分析中，我们没有考虑预测变量的交互项。在接下来的一节中，我们将考虑一个包含此因素的例子  

# 有交互项的多元线性回归  
#许多很有趣的研究都会涉及交互项的预测变量。以mtcars数据框中的汽车数据为例，若你对汽车重量和马力感兴趣，可以把它们作为预测变量，并包含交互项来拟合回归模型，参见代码  
fit <- lm(mpg ~ hp + wt + hp:wt, data=mtcars)  
summary(fit)  
#你可以看到Pr(>|t|)栏中，马力与车重的交互项是显著的，这意味着什么呢？若两个预测变量的交互项显著，说明响应变量与其中一个预测变量的关系依赖于另外一个预测变量的水平。因此此例说明，每加仑汽油行驶英里数与汽车马力的关系依车重不同而不同  

#通过effects包中的effect()函数，你可以用图形展示交互项的结果。格式为：  
plot(effect(term, mod,, xlevels), multiline=TRUE)   
#term即模型要画的项，mod为通过lm()拟合的模型，xlevels是一个列表，指定变量要设定的常量值，multiline=TRUE选项表示添加相应直线。对于上例，即：  
library(effects)   
plot(effect("hp:wt",fit,, list(wt=c(2.2,3.2,4.2))), multiline=TRUE)  

#然而，拟合模型只不过是分析的第一步，一旦拟合了回归模型，在信心十足地进行推断之前，必须对方法中暗含的统计假设进行检验。这正是下节的主题  

# 回归诊断  
# 现在让我们通过confint()函数的输出来看看8.2.4节中states多元回归的问题。  
states <- as.data.frame(state.x77[,c("Murder", "Population",   
                                     "Illiteracy", "Income", "Frost")])   
fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, data=states)   
confint(fit)  
# 结果表明，文盲率改变1%，谋杀率就在95%的置信区间[2.38, 5.90]中变化。另外，因为Frost  
# 的置信区间包含0，所以可以得出结论：当其他变量不变时，温度的改变与谋杀率无关。不过，你对这些结果的信念，都只建立在你的数据满足统计假设的前提之上。回归诊断技术向你提供了评价回归模型适用性的必要工具，它能帮助发现并纠正问题  

#R基础安装中提供了大量检验回归分析中统计假设的方法。最常见的方法就是对lm()函数返回的对象使用plot()函数，可以生成评价模型拟合情况的四幅图形。下面是简单线性回归的例子：  
fit <- lm(weight ~ height, data=women)   
par(mfrow=c(2,2))   
plot(fit)  

# 让我们再看看二次拟合的诊断图。代码为：  
fit2 <- lm(weight ~ height + I(height^2), data=women)   
par(mfrow=c(2,2))   
plot(fit2)  

# 这第二组图表明多项式回归拟合效果比较理想，基本符合了线性假设、残差正态性（除了观测点13）和同方差性（残差方差不变）。观测点15看起来像是强影响点（根据是它有较大的Cook距离值），删除它将会影响参数的估计。事实上，删除观测点13和15，模型会拟合得会更好。使用：  
newfit <- lm(weight~ height + I(height^2), data=women[-c(13,15),])   
#即可拟合剔除点后的模型。但是对于删除数据，要非常小心，因为本应是你的模型去匹配数据，而不是反过来。  

#最后，我们再应用这个基本的方法，来看看states的多元回归问题。  
states <- as.data.frame(state.x77[,c("Murder", "Population",   
                                     "Illiteracy", "Income", "Frost")])   
fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, data=states)   
par(mfrow=c(2,2))   
plot(fit)  
#但是R中还有更好的工具可用，相比plot(fit)方法，我更推荐它们  
# car包提供了大量函数，大大增强了拟合和评价回归模型的能力  
# qqPlot()           分位数比较图  
# durbinWatsonTest() 对误差自相关性做 Durbin-Watson 检验  
# crPlots()          成分与残差图  
# ncvTest()          对非恒定的误差方差做得分检验  
# spreadLevelPlot()  分散水平检验  
# outlierTest()      Bonferroni 离群点检验  
# avPlots()          添加的变量图形  
# inluencePlot()     回归影响图  
# scatterplot()      增强的散点图  
# scatterplotMatrix() 增强的散点图矩阵  
# vif()              方差膨胀因子  

1. 正态性  
#与基础包中的plot()函数相比，qqPlot()函数提供了更为精确的正态假设检验方法，它画出了在n–p–1个自由度的t分布下的学生化残差（studentized residual，也称学生化删除残差或折叠化残差）图形，其中n是样本大小，p是回归参数的数目（包括截距项）。代码如下：  
library(car)   
states <- as.data.frame(state.x77[,c("Murder", "Population",   
                                     "Illiteracy", "Income", "Frost")])   
fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, data=states)   
qqPlot(fit, labels=row.names(states), id.method="identify",   
       simulate=TRUE, main="Q-Q Plot")   
#qqPlot()函数生成的概率图见图8-9。id.method = "identify"选项能够交互式绘图——待图形绘制后，用鼠标单击图形内的点，将会标注函数中labels选项的设定值。敲击Esc键，从图形下拉菜单中选择Stop，或者在图形上右击，都将关闭这种交互模式。此处，我已经鉴定出了Nevada异常。当simulate=TRUE时，95%的置信区间将会用参数自助法（自助法可参见第12章）生成。  

#除了Nevada，所有的点都离直线很近，并都落在置信区间内，这表明正态性假设符合得很好。但是你也必须关注Nevada，它有一个很大的正残差值（真实值－预测值），表明模型低估了该州的谋杀率。特别地：  
states["Nevada",]  
fitted(fit)["Nevada"]  
residuals(fit)["Nevada"]  
rstudent(fit)["Nevada"]  
# 可以看到，Nevada的谋杀率是11.5%，而模型预测的谋杀率为3.9%  

# 可视化误差还有其他方法，比如使用代码清单8-6中的代码。residplot()函数生成学生化残差柱状图（即直方图），并添加正态曲线、核密度曲线和轴须图。它不需要加载car包。  
#绘制学生化残差图的函数  
residplot <- function(fit, nbreaks=10) {   
  z <- rstudent(fit)   
  hist(z, breaks=nbreaks, freq=FALSE,   
       xlab="Studentized Residual",   
       main="Distribution of Errors")   
  rug(jitter(z), col="brown")   
  curve(dnorm(x, mean=mean(z), sd=sd(z)),   
        add=TRUE, col="blue", lwd=2)   
  lines(density(z)$x, density(z)$y,   
        col="red", lwd=2, lty=2)   
  legend("topright",   
         legend = c( "Normal Curve", "Kernel Density Curve"),   
         lty=1:2, col=c("blue","red"), cex=.7)   
}   
residplot(fit)  
# 正如你所看到的，除了一个很明显的离群点，误差很好地服从了正态分布。虽然Q-Q图已经蕴藏了很多信息，但我总觉得从一个柱状图或者密度图测量分布的斜度比使用概率图更容易。因此为何不一起使用这两幅图呢？  

#2. 误差的独立性  
#之前章节提过，判断因变量值（或残差）是否相互独立，最好的方法是依据收集数据方式的先验知识。例如，时间序列数据通常呈现自相关性——相隔时间越近的观测相关性大于相隔越远的观测。car包提供了一个可做Durbin-Watson检验的函数，能够检测误差的序列相关性。在多元回归中，使用下面的代码可以做Durbin-Watson检验：  
durbinWatsonTest(fit)   

#p值不显著（p=0.282）说明无自相关性，误差项之间独立。滞后项（lag=1）表明数据集中每个数据都是与其后一个数据进行比较的。该检验适用于时间独立的数据，对于非聚集型的数据并不适用。注意，durbinWatsonTest()函数使用自助法（参见第12章）来导出p值。如果添加了选项simulate=TRUE，则每次运行测试时获得的结果都将略有不同。  

#3. 线性  
#通过成分残差图（component plus residual plot）也称偏残差图（partial residual plot），你可以看看因变量与自变量之间是否呈非线性关系，也可以看看是否有不同于已设定线性模型的系统偏差，图形可用car包中的crPlots()函数绘制。创建变量X的成分残差图，需要绘制点 。代码如下：  
library(car)   
crPlots(fit)   
#结果如图8-11所示。若图形存在非线性，则说明你可能对预测变量的函数形式建模不够充分，  
#那么就需要添加一些曲线成分，比如多项式项，或对一个或多个变量进行变换（如用log(X)代 替X），或用其他回归变体形式而不是线性回归。本章稍后会介绍变量变换  

#检验同方差性  
library(car)   
ncvTest(fit)  
spreadLevelPlot(fit)  


#线性模型假设的综合验证  
#最后，让我们一起学习gvlma包中的gvlma()函数。gvlma()函数由Pena和Slate（2006）编写，能对线性模型假设进行综合验证，同时还能做偏斜度、峰度和异方差性的评价。换句话说，它给模型假设提供了一个单独的综合检验（通过/不通过）。代码清单8-8是对states数据的检验。  
library(gvlma)   
gvmodel <- gvlma(fit)   
summary(gvmodel)  
#从输出项（Global Stat中的文字栏）我们可以看到数据满足OLS回归模型所有的统计假设（p=0.597）。若Decision下的文字表明违反了假设条件（比如p<0.05），你可以使用前几节讨论的方法来判断哪些假设没有被满足  


## 异常观测值  
#你已经学习过一种鉴别离群点的方法：图8-9的Q-Q图，落在置信区间带外的点即可被认为是离群点。另外一个粗糙的判断准则：标准化残差值大于2或者小于–2的点可能是离群点，需要特别关注。  
#car包也提供了一种离群点的统计检验方法。outlierTest()函数可以求得最大标准化残差绝对值Bonferroni调整后的p值：  
library(car)   
outlierTest(fit)  
#此处，你可以看到Nevada被判定为离群点（p=0.048）。注意，该函数只是根据单个最大（或正或负）残差值的显著性来判断是否有离群点。若不显著，则说明数据集中没有离群点；若显著，则你必须删除该离群点，然后再检验是否还有其他离群点存在  

#改进措施  
#我们已经花费了不少篇幅来学习回归诊断，你可能会问：“如果发现了问题，那么能做些什么呢？”有四种方法可以处理违背回归假设的问题：  
#  删除观测点；  
#  变量变换；  
#  添加或删除变量；  
#  使用其他回归方法。  
# 下面让我们依次学习。  


## 选择“最佳”的回归模型  
#模型比较  
#用基础安装中的anova()函数可以比较两个嵌套模型的拟合优度。所谓嵌套模型，即它的一些项完全包含在另一个模型中。在states的多元回归模型中，我们发现Income和Frost的回归系数不显著，此时你可以检验不含这两个变量的模型与包含这两项的模型预测效果是否一样好  

#用anova()函数比较  
states <- as.data.frame(state.x77[,c("Murder", "Population",   
                                     "Illiteracy", "Income", "Frost")])   
fit1 <- lm(Murder ~ Population + Illiteracy + Income + Frost,   
           data=states)   
fit2 <- lm(Murder ~ Population + Illiteracy, data=states)   
anova(fit2, fit1)  
#此处，模型1嵌套在模型2中。anova()函数同时还对是否应该添加Income和Frost到线性模型中进行了检验。由于检验不显著（p=0.994），我们可以得出结论：不需要将这两个变量添加到线性模型中，可以将它们从模型中删除  

#AIC（Akaike Information Criterion，赤池信息准则）也可以用来比较模型，它考虑了模型的统计拟合度以及用来拟合的参数数目。AIC值较小的模型要优先选择，它说明模型用较少的参数获得了足够的拟合度。该准则可用AIC()函数实现  
#用AIC来比较模型  
fit1 <- lm(Murder ~ Population + Illiteracy + Income + Frost,   
           data=states)   
fit2 <- lm(Murder ~ Population + Illiteracy, data=states)   
AIC(fit1,fit2)  
# 此处AIC值表明没有Income和Frost的模型更佳。注意，ANOVA需要嵌套模型，而AIC方法不需要。  
# 比较两模型相对来说更为直接，但如果有4个、10个或者100个可能的模型该怎么办呢？  






