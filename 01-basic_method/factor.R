diabetes <- c("Type1", "Type2", "Type1", "Type1")
diabetes <- factor(diabetes)

patientID <- c(1,2,3,4)
age <- c(25,34,28,52)
diabetes <- c("Type1",'Type2','Type1','Type1')
status <- c('poor','Improved','Excellent','Poor')
diabetes <- factor(diabetes)
status <- factor(status,order=TRUE)
patientdata <- data.frame(patientID,age,diabetes,status)
str(patientdata)
summary(patientdata)

#函数factor()可为类别型变量创建值标签。
#假设你有一个名为gender的变量，其中1表示男性，2表示女性。你可以使用代码来创建值标签
#这里levels代表变量的实际值，而labels表示包含了理想值标签的字符型向量
patientdata$gender <- factor(patientdata$gender, 
                             levels = c(1,2), 
                             labels = c("male", "female")) 

