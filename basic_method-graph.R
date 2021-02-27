# 基本方法 basic_method-graph
#install.packages("vcd") # 加载vcd包
library("vcd")
#barplot(height)  # 其中的height是一个向量或一个矩阵。

counts <- table(Arthritis$Improved) 

#简单的条形图
barplot(counts, 
        main="Simple Bar Plot", 
        xlab="Improvement", ylab="Frequency") 
barplot(counts, 
        main="Horizontal Bar Plot", 
        xlab="Frequency", ylab="Improvement",
        horiz=TRUE)

plot(Arthritis$Improved, main="Simple Bar Plot", 
     xlab="Improved", ylab="Frequency") 
plot(Arthritis$Improved, horiz=TRUE, main="Horizontal Bar Plot", 
     xlab="Frequency", ylab="Improved")

# 堆砌条形图和分组条形图
# library(vcd) 
counts <- table(Arthritis$Improved, Arthritis$Treatment)

# 堆砌条形图和分组条形图
barplot(counts, 
        main="Stacked Bar Plot", 
        xlab="Treatment", ylab="Frequency", 
        col=c("red", "yellow","green"), 
        legend=rownames(counts)) 
barplot(counts, 
        main="Grouped Bar Plot", 
        xlab="Treatment", ylab="Frequency", 
        col=c("red", "yellow", "green"), 
        legend=rownames(counts), beside=TRUE)

#排序后均值的条形图
states <- data.frame(state.region, state.x77) 
means <- aggregate(states$Illiteracy, by=list(state.region), FUN=mean)
means <- means[order(means$x),]
barplot(means$x, names.arg=means$Group.1)
title("Mean Illiteracy Rate")

# 为条形图搭配标签
par(mar=c(5,8,4,2)) 
par(las=2)
counts <- table(Arthritis$Improved) 
barplot(counts, 
        main="Treatment Outcome", 
        horiz=TRUE, 
        cex.names=0.8,
        names.arg=c("No Improvement", "Some Improvement", 
                    "Marked Improvement"))

# 饼图
par(mfrow=c(2, 2))
slices <- c(10, 12,4, 16, 8) 
lbls <- c("US", "UK", "Australia", "Germany", "France") 
pie(slices, labels = lbls, 
    main="Simple Pie Chart") 
pct <- round(slices/sum(slices)*100) 
lbls2 <- paste(lbls, " ", pct, "%", sep="") 
pie(slices, labels=lbls2, col=rainbow(length(lbls2)),
    main="Pie Chart with Percentages") 
library(plotrix) 
pie3D(slices, labels=lbls,explode=0.1, 
      main="3D Pie Chart ") 
mytable <- table(state.region)
lbls3 <- paste(names(mytable), "\n", mytable, sep="") 
pie(mytable, labels = lbls3, 
    main="Pie Chart from a Table\n (with sample sizes)")

# 扇形
slices <- c(10, 12,4, 16, 8) 
lbls <- c("US", "UK", "Australia", "Germany", "France") 
fan.plot(slices, labels = lbls, main="Fan Plot")

# 直方图
par(mfrow=c(2,2)) 
hist(mtcars$mpg)
hist(mtcars$mpg, 
     breaks=12, 
     col="red", 
     xlab="Miles Per Gallon", 
     main="Colored histogram with 12 bins") 
hist(mtcars$mpg, 
     freq=FALSE, 
     breaks=12, 
     col="red", 
     xlab="Miles Per Gallon", 
     main="Histogram, rug plot, density curve")
rug(jitter(mtcars$mpg)) 
lines(density(mtcars$mpg), col="blue", lwd=2) 
x <- mtcars$mpg 
h<-hist(x, 
        breaks=12, 
        col="red", 
        xlab="Miles Per Gallon", 
        main="Histogram with normal curve and box") 
xfit<-seq(min(x), max(x), length=40) 
yfit<-dnorm(xfit, mean=mean(x), sd=sd(x)) 
yfit <- yfit*diff(h$mids[1:2])*length(x)
lines(xfit, yfit, col="blue", lwd=2) 
box()

# 核密度图
par(mfrow=c(2,1)) 
d <- density(mtcars$mpg) 
plot(d) 
d <- density(mtcars$mpg)
plot(d, main="Kernel Density of Miles Per Gallon")
polygon(d, col="red", border="blue")
rug(mtcars$mpg, col="brown")

# # 可比较的核密度图
# library('sm') 
# attach(mtcars) 
# cyl.f <- factor(cyl, levels= c(4,6,8), 
#                 labels = c("4 cylinder", "6 cylinder",
#                            "8 cylinder")) 
# sm.density.compare(mpg, cyl, xlab="Miles Per Gallon") 
# title(main="MPG Distribution by Car Cylinders") 
# colfill<-c(2:(1+length(levels(cyl.f)))) 
# legend(locator(1), levels(cyl.f), fill=colfill)
# detach(mtcars)

# 箱线图
boxplot(mtcars$mpg, main="Box plot", ylab="Miles per Gallon")
# boxplot(formula, data=dataframe)
boxplot(mpg ~ cyl, data=mtcars, 
        main="Car Mileage Data", 
        xlab="Number of Cylinders", 
        ylab="Miles Per Gallon")

boxplot(mpg ~ cyl, data=mtcars, 
        notch=TRUE, 
        varwidth=TRUE, 
        col="red", 
        main="Car Mileage Data", 
        xlab="Number of Cylinders", 
        ylab="Miles Per Gallon")

# 两个交叉因子的箱线图
mtcars$cyl.f <- factor(mtcars$cyl, 
                       levels=c(4,6,8), 
                       labels=c("4","6","8")) 
mtcars$am.f <- factor(mtcars$am, 
                      levels=c(0,1), 
                      labels=c("auto", "standard"))
boxplot(mpg ~ am.f *cyl.f, 
        data=mtcars, 
        varwidth=TRUE, 
        col=c("gold","darkgreen"), 
        main="MPG Distribution by Auto Type", 
        xlab="Auto Type", ylab="Miles Per Gallon")

# 点图
# dotchart(x, labels=)
dotchart(mtcars$mpg, labels=row.names(mtcars), cex=.7, 
         main="Gas Mileage for Car Models", 
         xlab="Miles Per Gallon")

# 分组、排序、着色后的点图
x <- mtcars[order(mtcars$mpg),] 
x$cyl <- factor(x$cyl)
x$color[x$cyl==4] <- "red" 
x$color[x$cyl==6] <- "blue" 
x$color[x$cyl==8] <- "darkgreen" 
dotchart(x$mpg, 
         labels = row.names(x),
         cex=.7, 
         groups = x$cyl, 
         gcolor = "black", 
         color = x$color,
         pch=19, 
         main = "Gas Mileage for Car Models\ngrouped by cylinder", 
         xlab = "Miles Per Gallon")
