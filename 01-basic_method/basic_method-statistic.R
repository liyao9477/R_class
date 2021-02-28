# basic_method-statistic
# 描述统计
mystats <- function(x, na.omit=FALSE){ 
  if (na.omit) 
    x <- x[!is.na(x)] 
  m <- mean(x) 
  n <- length(x) 
  s <- sd(x) 
  skew <- sum((x-m)^3/s^3)/n 
  kurt <- sum((x-m)^4/s^4)/n - 3 
  return(c(n=n, mean=m, stdev=s, skew=skew, kurtosis=kurt)) 
} 

myvars <- c("mpg", "hp", "wt") 
sapply(mtcars[myvars], mystats)
sapply(mtcars[myvars], mystats, na.omit=TRUE)

#通过Hmisc包中的describe()函数计算描述性统计量
library(Hmisc) 
myvars <- c("mpg", "hp", "wt") 
describe(mtcars[myvars])

# pastecs包中的stat.desc()的函数
library(pastecs)
stat.desc(mtcars[myvars],norm = T)

#psych包中的describe()函数
psych::describe(mtcars[myvars])

#str()函数

# 分组计算描述性统计量
aggregate(mtcars[myvars], by=list(am=mtcars$am), mean)
aggregate(mtcars[myvars], by=list(am=mtcars$am), sd)
# 注意list(am=mtcars$am)的使用。如果使用的是list(mtcars$am)，则am列将被标注为Group.1而不是am。你使用这个赋值指定了一个更有帮助的列标签。如果有多个分组变量，可以使用by=list(name1=groupvar1, name2=groupvar2, ... , nameN=groupvarN)这样的语句
# 遗憾的是，aggregate()仅允许在每次调用中使用平均数、标准差这样的单返回值函数。它无法一次返回若干个统计量。要完成这项任务，可以使用by()函数。格式为：by(data, INDICES, FUN)
dstats <- function(x)sapply(x, mystats) 
myvars <- c("mpg", "hp", "wt") 
by(mtcars[myvars], mtcars$am, dstats)

#doBy包中summaryBy()函数的使用格式为：
#summaryBy(formula, data=dataframe, FUN=function)
library(doBy) 
summaryBy(mpg+hp+wt~am, data=mtcars, FUN=mystats)

#使用psych包中的describeBy()分组计算概述统计量
library(psych) 
myvars <- c("mpg", "hp", "wt") 
describeBy(mtcars[myvars], list(am=mtcars$am))
# 若存
#在一个以上的分组变量，你可以使用list(name1=groupvar1, name2=groupvar2, ... , nameN=groupvarN)来表示它们。但这仅在分组变量交叉后不出现空白单元时有效。



