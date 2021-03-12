library(rlist)  
devs <-   
  list(  
    p1=list(name="Ken",age=24,  
            interest=c("reading","music","movies"),  
            lang=list(r=2,csharp=4,python=3)),  
    p2=list(name="James",age=25,  
            interest=c("sports","music"),  
            lang=list(r=3,java=2,cpp=5)),  
    p3=list(name="Penny",age=24,  
            interest=c("movies","reading"),  
            lang=list(r=1,cpp=4,python=2)))  
str(devs)  
# 以下尝试转df处理，不理想  
df_devs <- as.data.frame(unlist(devs))  
df_devs2 <- as.data.frame(t(df_devs)) # -end  

# 1 list.map  
list.map(devs, age)  
# 将每个元素映射到使用编程语言的平均年数：  
list.map(devs, mean(as.numeric(lang)))  
# 将每个元素映射到使用的编程语言名称：  
list.map(devs, names(lang))  

# 2 list.filter  
str(list.filter(devs, age>=25))  
# 使用R语言的  
str(list.filter(devs, "r" %in% names(lang)))  
# Python不低于3年的  
str(list.filter(devs, lang$python >= 3))  

# 3 list.group  
str(list.group(devs, age))  
# 按照兴趣  
str(list.class(devs, interest))  

# 4 list.sort  
str(list.sort(devs, age))  
# 按照使用兴趣数量降序排列，然后按照R语言使用年数降序排列：  
str(list.sort(devs, desc(length(interest)), desc(lang$r)))  

# 5 str.update  
#去除interest和lang两个字段，加入nlang表示掌握语言数目，以及expert使用时间最长的语言名称：  
str(list.update(devs, interest=NULL, lang=NULL, nlang=length(lang),  
                expert={  
                  longest <- sort(unlist(lang))[1]  
                  names(longest)  
                }))  

# Lambda表达式  
# rlist中所有支持表达式计算的函数都支持 Lambda 表达式，允许用户访问列表元素的元数据（metadata），即元素本身、元素索引编号（index）、元素名称（name）  
x <- list(a=c(1,2,3),b=c(3,4,5))  
list.map(x, sum(.))  
list.map(x, x -> sum(x))  
默认情况下，.i表示当前元素的索引，.name表示当前元素的名称。下面用list.iter函数遍历x中的各个元素，对于每个元素显示自定义字符串  
list.iter(x, cat(.name,":",.i,"\n"))  
通过 Lambda 表达式自定义这些符号时，可以采用 f(x,i,name) -> expression 的形式，例如  
list.map(x, f(x,i) -> x*i)  

# 管道符  
library(pipeR)  
devs %>>%   
  list.filter("music" %in% interest & "r" %in% names(lang)) %>>%  
  list.select(name,age) %>>%  
  list.rbind %>>%  
  data.frame  

set.seed(1)  
1:10 %>>%  
  list.map(i -> {  
    x <- rnorm(1000)  
    y <- i * x + rnorm(1000)  
    data.frame(x=x,y=y)  
  }) %>>%  
  list.map(df -> lm(y~x)) %>>%  
  list.update(summary = m -> summary(m)) %>>%  
  list.sort(m -> desc(summary$r.squared)) %>>%  
  list.map(c(rsq=summary$r.squared, coefficients)) %>>%  
  list.rbind %>>%  
  data.frame  

# 除了上述函数之外，rlist扩展包还提供了许多其他函数，这里只做简单介绍：  
#   
# list.join：根表达式合并两个list  
# list.parse：将其他类型的对象转换为结构相同的list  
# list.load, list.save：读写JSON, YAML, RData格式的list  
# list.if, list.which, list.any, list.all：list元素的逻辑判断  
# list.find, list.findi：在list中按照表达式寻找指定数量的元素  

# 详细介绍请参见帮助文档：  
#   
# help(package = rlist)  
