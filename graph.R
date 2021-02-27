pdf("mygraph.pdf") 
attach(mtcars) 
plot(wt, mpg) 
abline(lm(mpg~wt)) 
title("Regression of MPG on Weight") 
detach(mtcars) 
dev.off()

dose <- c(20, 30, 40, 45, 60) 
drugA <- c(16, 20, 27, 40, 60) 
drugB <- c(15, 18, 25, 31, 40)
plot(dose, drugA, type="b")

# 使用实心三角而不是空心圆圈作为点的符号，并且想用虚线代替，实线连接这些点
opar <- par(no.readonly=TRUE) 
par(lty=2, pch=17)
plot(dose, drugA, type="b")
par(opar)

# ---- >>>>
plot(dose, drugA, type="b", lty=2, pch=17)
plot(dose, drugA, type="b", lty=3, lwd=3, pch=15, cex=2)
# col,col.axis,col.lab,col.main,col.sub,fg,bg
# col=1、col="white"、col="#FFFFFF"、col=rgb(1,1,1)、col=hsv(0,0,1)
# rainbow(10)
n <- 10 
mycolors <- rainbow(n) 
pie(rep(1, n), labels=mycolors, col=mycolors) 
mygrays <- gray(0:n/n) 
pie(rep(1, n), labels=mygrays, col=mygrays)

# 生成一幅4英寸宽、3英寸高、上下边界为1英寸、左边界为0.5英寸、右边界为0.2英寸的图形
par(pin=c(4,3), mai=c(1,.5, 1, .2))

plot(dose, drugA, type="b", 
     col="red", lty=2, pch=2, lwd=2, 
     main="Clinical Trials for Drug A", 
     sub="This is hypothetical data", 
     xlab="Dosage", ylab="Drug Response", 
     xlim=c(0, 60), ylim=c(0, 70))

# 标题
title(main="My Title", col.main="red", 
      sub="My Subtitle", col.sub="blue", 
      xlab="My X label", ylab="My Y label", 
      col.lab="green", cex.lab=0.75)
# 坐标轴
axis(side, at=, labels=, pos=, lty=, col=, las=, tck=, ...)
# 参考线
abline(h=yvalues, v=xvalues)
abline(v=seq(1, 10, 2), lty=2, col="blue")
# 图例
legend("topleft", inset=.05, title="Drug Type", c("A","B"),lty=c(1, 2), pch=c(15, 17), col=c("red", "blue"))

# 文本标记
#我们可以通过函数text()和mtext()将文本添加到图形上。text()可向绘图区域内部添加文本，而mtext()则向图形的四个边界之一添加文本。使用格式分别为：
text(location, "text to place", pos, ...) 
mtext("text to place", side, line=n, ...)

## 图形的组合
attach(mtcars) 
opar <- par(no.readonly=TRUE) 
par(mfrow=c(2,2))
plot(wt,mpg, main="Scatterplot of wt vs. mpg") 
plot(wt,disp, main="Scatterplot of wt vs. disp") 
hist(wt, main="Histogram of wt") 
boxplot(wt, main="Boxplot of wt") 
par(opar) 
detach(mtcars)

#作为第二个示例，让我们依三行一列排布三幅图形。代码如下：
attach(mtcars) 
opar <- par(no.readonly=TRUE) 
par(mfrow=c(3,1)) 
hist(wt) 
hist(mpg) 
hist(disp) 
par(opar) 
detach(mtcars)
