# 无论你走到哪里，都将成为数据分析师艳羡的人物！）
# data clean
manager <- c(1, 2, 3, 4, 5) 
date <- c("10/24/08", "10/28/08", "10/1/08", "10/12/08", "5/1/09") 
country <- c("US", "US", "UK", "UK", "UK") 
gender <- c("M", "F", "F", "M", "F") 
age <- c(32, 45, 25, 39, 99) 
q1 <- c(5, 3, 3, 3, 2) 
q2 <- c(4, 5, 5, 3, 2) 
q3 <- c(5, 2, 5, 4, 1) 
q4 <- c(5, 5, 5, NA, 2) 
q5 <- c(5, 5, 2, NA, 1) 
leadership <- data.frame(manager, date, country, gender, age, q1, q2, q3, q4, q5, stringsAsFactors=FALSE)

###-----------------------
# 为了解决感兴趣的问题，你必须首先解决一些数据管理方面的问题。
# 这里列出其中一部分。
# 1.五个评分（q1到q5）需要组合起来，即为每位经理人生成一个平均服从程度得分。
# 2.在问卷调查中，被调查者经常会跳过某些问题。例如，为4号经理人打分的上司跳过了问题4和问题5。你需要一种处理不完整数据的方法，同时也需要将99岁这样的年龄值重编码为缺失值。
# 3.一个数据集中也许会有数百个变量，但你可能仅对其中的一些感兴趣。为了简化问题，我们往往希望创建一个只包含那些感兴趣变量的数据集。
# 4.既往研究表明，领导行为可能随经理人的年龄而改变，二者存在函数关系。要检验这种观点，你希望将当前的年龄值重编码为类别型的年龄组（例如年轻、中年、年长）。
# 5.领导行为可能随时间推移而发生改变。你可能想重点研究最近全球金融危机期间的服从行为。为了做到这一点，你希望将研究范围限定在某一个特定时间段收集的数据上（比如，2009年1月1日到2009年12月31日）
x1 <- c(2,6)
x2 <- c(5,8)
mydata <- data.frame(x1,x2)
# 创建-新变量
attach(mydata) 
mydata$sumx <- x1 + x2 
mydata$meanx <- (x1 + x2)/2 
detach(mydata)
    # --like:
mydata <- transform(mydata, 
                    sumx = x1 + x2, 
                    meanx = (x1 + x2)/2)
transform(mydata,sumx = NULL) # 删除某一列
# transform可以用within函数代替 within(df,{})

# 数据处理-重编码
leadership$age[leadership$age == 99] <- NA
leadership$agecat[leadership$age > 75] <- "Elder" 
leadership$agecat[leadership$age >= 55 & 
                    leadership$age <= 75] <- "Middle Aged" 
leadership$agecat[leadership$age < 55] <- "Young"
    # --like
leadership <- within(leadership,{ 
  agecat <- NA 
  agecat[age > 75] <- "Elder" 
  agecat[age >= 55 & age <= 75] <- "Middle Aged" 
  agecat[age < 55] <- "Young" })

# 若干程序包都提供了实用的变量重编码函数，特别地，car包中的recode()函数可以十分简便地重编码数值型、字符型向量或因子。而doBy包提供了另外一个很受欢迎的函数recodevar()。最后，R中也自带了cut()，可将一个数值型变量按值域切割为多个区间，并返回一个因子。
# 重命名
fix(leadership)
names(leadership)[2] <- "testDate"
names(leadership)[6:10] <- c("item1", "item2", "item3", "item4", "item5")

# 缺失值
is.na(leadership[,6:10])
is.infinite()
is.nan()
x <- c(1, 2, NA, 3) 
y <- sum(x, na.rm=TRUE)
na.omit()

# 日期值
mydates <- as.Date(c("2007-06-22", "2004-02-13"))
strDates <- c("01/05/1965", "08/16/1975") 
dates <- as.Date(strDates, "%m/%d/%Y")
myformat <- "%m/%d/%y" 
leadership$date <- as.Date(leadership$testDate, myformat)
Sys.Date()
date()
format(today, format="%B %d %Y")
format(today, format="%A")
startdate <- as.Date("2004-02-13") 
enddate <- as.Date("2011-01-22") 
days <- enddate - startdate 

today <- Sys.Date() 
dob <- as.Date("1956-10-12") 
difftime(today, dob, units="weeks")

# 类型转换
is.numeric()    as.numeric() 
is.character()  as.character() 
is.vector()     as.vector() 
is.matrix()     as.matrix() 
is.data.frame() as.data.frame() 
is.factor()     as.factor() 
is.logical()    as.logical()
#当和控制流（如if-then）结合使用时，is.datatype()这样的函数将成为一类强大的工具，即允许根据数据的具体类型以不同的方式处理数据

# 排序
newdata <- leadership[order(leadership$age),]
attach(leadership) 
newdata <- leadership[order(gender, age),] 
detach(leadership)

attach(leadership) 
newdata <-leadership[order(gender, -age),] 
detach(leadership)

# 合并
#要横向合并两个数据框（数据集），请使用merge()函数。在多数情况下，两个数据框是通过一个或多个共有变量进行联结的（即一种内联结，inner join）
total <- merge(dataframeA, dataframeB, by="ID")
total <- merge(dataframeA, dataframeB, by=c("ID","Country"))
total <- cbind(A, B) 
#cbind这个函数将横向合并对象A和对象B。为了让它正常工作，每个对象必须拥有相同的行数，以同顺序排序
total <- rbind(dataframeA, dataframeB) 
#rbind两个数据框必须拥有相同的变量，不过它们的顺序不必一定相同

# 读取，切片
newdata <- leadership[, c(6:10)]
myvars <- c("q1", "q2", "q3", "q4", "q5") 
newdata <-leadership[myvars]

myvars <- paste("q", 1:5, sep="") 
newdata <- leadership[myvars] # 本例使用paste()函数创建了与上例中相同的字符型向量

myvars <- names(leadership) %in% c("q3", "q4") 
newdata <- leadership[!myvars] # 剔除变量

leadership$date <- as.Date(leadership$date, "%m/%d/%y") 
startdate <- as.Date("2009-01-01") 
enddate <- as.Date("2009-10-31")
newdata <- leadership[which(leadership$date >= startdate &
                              leadership$date <= enddate),]

#使用subset()函数大概是选择变量和观测最简单的方法了。两个示例如下：
newdata <- subset(leadership, age >= 35 | age < 24, 
                  select=c(q1, q2, q3, q4)) 
newdata <- subset(leadership, gender=="M" & age > 25,
                  select=gender:q4)

# 统计，抽样
mysample <- leadership[sample(1:nrow(leadership), 3, replace=FALSE),] 
# sample()函数中的第一个参数是一个由要从中抽样的元素组成的向量。在这里，这个向量是1到数据框中观测的数量，第二个参数是要抽取的元素数量，第三个参数表示无放回抽样。
# sample()函数会返回随机抽样得到的元素，之后即可用于选择数据框中的行。
# R中拥有齐全的抽样工具，包括抽取和校正调查样本（参见sampling包）以及分析复杂调查数据（参见survey包）的工具。其他依赖于抽样的方法，包括自助法和重抽样统计方法

# SQL操作
install.packages("sqldf")
library(sqldf) 
newdf <- sqldf("select * from mtcars where carb=1 order by mpg", 
                 row.names=TRUE) 
sqldf("select avg(mpg) as avg_mpg, avg(disp) as avg_disp, gear 
 from mtcars where cyl in (4, 6) group by gear")


