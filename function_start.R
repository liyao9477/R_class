# function_start
# mystats()：一个由用户编写的描述性统计量计算函数
mystats <- function(x, parametric=TRUE, print=FALSE) { 
  if (parametric) { 
    center <- mean(x); spread <- sd(x) 
  } else { 
    center <- median(x); spread <- mad(x) 
  } 
  if (print & parametric) { 
    cat("Mean=", center, "\n", "SD=", spread, "\n") 
  } else if (print & !parametric) { 
    cat("Median=", center, "\n", "MAD=", spread, "\n") 
  } 
  result <- list(center=center, spread=spread) 
  return(result) 
}

# 验证
set.seed(1234) 
x <- rnorm(500)
y <- mystats(x)
y <- mystats(x, parametric=FALSE, print=TRUE)

# 此函数可让用户选择输出当天日期的格式
mydate <- function(type="long") { 
  switch(type, 
         long = format(Sys.time(), "%A %B %d %Y"), 
         short = format(Sys.time(), "%m-%d-%y"), 
         cat(type, "is not a recognized type\n") 
  ) 
}
mydate("long") 
mydate("short")
mydate() 
mydate("medium") 
#请注意，函数cat()仅会在输入的日期格式类型不匹配"long"或"short"时执行。使用一个表达式来捕获用户的错误输入的参数值通常来说是一个好主意

# 你可以使用函数warning()来生成一条错误提示信息，
# 用message()来生成一条诊断信息
# 或用stop()停止当前表达式的执行并提示错误

# 数据集的转置
cars <- mtcars[1:5,1:4]
t(cars)

# 整合数据
# 在R中使用一个或多个by变量和一个预先定义好的函数来折叠（collapse）数据是比较容易的。调用格式为：
aggregate(x, by, FUN) 
#其中x是待折叠的数据对象，by是一个变量名组成的列表，这些变量将被去掉以形成新的观测，而FUN则是用来计算描述性统计量的标量函数，它将被用来计算新观测中的值
options(digits=3) 
attach(mtcars) 
aggdata <-aggregate(mtcars, by=list(cyl,gear), FUN=mean, na.rm=TRUE) 
aggdata
#aggregate函数对数据集中的cyl与gear两个条件求出各组的平均值，非常强大的功能
aggdata<-aggregate(mtcars,by=list(cyl,gear),FUN=mean,na.rm=TRUE)
#可以解释第一行的数据为cyl为4和gear为3时，其它变量disp，hp等的平均值
#这是非常可怕的功能，可以自由的折叠，提取数据子集

## reshape2包
#大致说来，你需要首先将数据融合（melt），以使每一行都是唯一的标识符变量组合。然后将数据重铸（cast）为你想要的任何形状。在重铸过程中，你可以使用任何函数对数据进行整合。
#library(reshape2) 
mydata <- rbind(c(1,1,5,6),c(1,2,3,5),c(2,1,6,1),c(2,2,2,4))
colnames(mydata) <- c('ID','Time','X1','X2')
md <- melt(mydata, id=c("ID", "Time"))
# 注意，必须指定要唯一确定每个测量所需的变量（ID和Time），而表示测量变量名的变量（X1或X2）将由程序为你自动创建

newdata <- dcast(md, formula, fun.aggregate)
# 其中的md为已融合的数据，formula描述了想要的最后结果，而fun.aggregate是（可选的）数据整合函数。其接受的公式形如：
# rowvar1 + rowvar2 + ... ~ colvar1 + colvar2 + ... 
# 在这一公式中，rowvar1 + rowvar2 + ...定义了要划掉的变量集合，以确定各行的内容，而colvar1 + colvar2 + ...则定义了要划掉的、确定各列内容的变量集合
#由于右侧（d、e和f）的公式中并未包括某个函数，所以数据仅被重塑了
#如你所见，函数melt()和dcast()提供了令人惊叹的灵活性。很多时候，你不得不在进行分析之前重塑或整合数据。举例来说，在分析重复测量数据（为每个观测记录了多个测量的数据）时，你通常需要将数据转化为类似于表5-9中所谓的长格式


