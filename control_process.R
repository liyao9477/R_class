# control process
# 语句（statement）是一条单独的R语句或一组复合语句（包含在花括号{ }中的一组R语句，使用分号分隔）；
# 条件（cond）是一条最终被解析为真（TRUE）或假（FALSE）的表达式；
# 表达式（expr）是一条数值或字符串的求值语句；
# 序列（seq）是一个数值或字符串序列。

# 循环
for (var in seq) statement
while (cond) statement
# 举例
i <- 10 
while (i > 0) {print("Hello"); i <- i - 1}
# 在处理大数据集中的行和列时，R中的循环可能比较低效费时。只要可能，最好联用R中的内建数值/字符处理函数和apply族函数

# if else
if (cond) statement
if (cond) statement1 else statement2

if (is.character(grade)) grade <- as.factor(grade) 
if (!is.factor(grade)) grade <- as.factor(grade) else print("Grade already 
                                                            is a factor")
# ifelse
ifelse(cond, statement1, statement2)
ifelse(score > 0.5, print("Passed"), print("Failed")) 
outcome <- ifelse (score > 0.5, "Passed", "Failed")
# switch
switch(expr, ...)
feelings <- c("sad", "afraid") 
for (i in feelings) 
  print( 
    switch(i, 
           happy = "I am glad you are happy", 
           afraid = "There is nothing to fear", 
           sad = "Cheer up", 
           angry = "Calm down now" 
    ) 
  )
