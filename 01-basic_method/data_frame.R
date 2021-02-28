aa <- data.frame(a = c(1,2),b=c(3,5),c=c(4,8))

summary(mtcars$mpg)
plot(mtcars$mpg, mtcars$disp)

# detach是可以省略的，但其实它应当被例行地放入代码中
# 在数据框mtcars被绑定（attach）之前，你们的环境中已经有了一个名为mpg的对象。在这种情况下，原始对象将取得优先权
attach(mtcars) 
summary(mpg) 
plot(mpg, disp) 
plot(mpg, wt) 
detach(mtcars)

# 函数with()的局限性在于，赋值仅在此函数的括号内生效
# 如果仅有一条语句（例如summary(mpg)），那么花括号{}可以省略
with(mtcars, { 
  print(summary(mpg)) 
  plot(mpg, disp) 
  plot(mpg, wt) 
})

# 如果你需要创建在with()结构以外存在的对象，使用特殊赋值符<<-替代标准赋值符（<-）即可，它可将对象保存到with()之外的全局环境中
with(mtcars, { 
  nokeepstats <- summary(mpg) 
  keepstats <<- summary(mpg) 
})

# 相对于attach()，多数的R书籍更推荐使用with()。个人认为从根本上说，选择哪一个是自己的偏好问题，并且应当根据你的目的和对于这两个函数含义的理解而定



# ---------------隔-----------------------------
# 函数
length()
dim()
str()
class()
mode()
names()
c()
cbind()
rbind()
object
head()
tail()
ls()
rm()
edit()




