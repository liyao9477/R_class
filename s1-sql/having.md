# having  
# 寻找缺失的编号  
seq name  
1 jimy  
2 lisy  
4 wangpi  
5 zhanghe  
思路  
1. 对“连续编号”列按升序或者降序进行排序。  
2. 循环比较每一行和下一行的编号。  

  -- 如果有查询结果，说明存在缺失的编号  
SELECT '存在缺失的编号' AS gap  
 FROM SeqTbl  
HAVING COUNT(*) <> MAX(seq);  

  -- 查询缺失编号的最小值  
SELECT MIN(seq + 1) AS gap  
 FROM SeqTbl  
 WHERE (seq+ 1) NOT IN ( SELECT seq FROM SeqTbl);  

  # 用 HAVING 子句进行子查询 ：求众数  
Graduates  
name income  
wangpi 2300  
zhanghe 3400  
lisheng 2000  
zhangdong 12000  
有些 DBMS 已经提供了用来求众数的函数，但其实用标准SQL也很简单.思路是将收入相同的毕业生汇总到一个集合里，然后从汇总后的各个集合里找出元素个数最多的集合  

  -- 求众数的 SQL 语句 (1)：使用谓词  
SELECT income, COUNT(*) AS cnt  
 FROM Graduates  
 GROUP BY income  
HAVING COUNT(	\*) >= ALL (SELECT COUNT(	\*)  
 FROM Graduates  
　　 GROUP BY income);  

  过 ALL 谓词用于 NULL 或空集时会出现问题，可以用极值函数来代替(MAX,MIN)  
-- 求众数的 SQL 语句 (2) ：使用极值函数  
SELECT income, COUNT(*) AS cnt  
 FROM Graduates  
 GROUP BY income  
HAVING COUNT(*) >= ( SELECT MAX(cnt)  
 FROM ( SELECT COUNT(*) AS cnt  
 FROM Graduates  
 GROUP BY income) TMP ) ;  

  如果要用面向过程语言的方法来求众数时，又该怎么做呢？  
要先按收入进行排序，然后一行一行地循环处理和中断控制，遇到某个收入值的人数超出前面一个收入值的人数时，将新的收入值赋给另一个变量并保存，以便后续使用。我们能发现，与这种做法相比，使用 SQL 既不需要循环也不需要赋值。  

  # 用 HAVING 子句进行自连接 ：求中位数  

  -- 求中位数的 SQL 语句 ：在 HAVING 子句中使用非等值自连接  
SELECT AVG(DISTINCT income)  
 FROM (SELECT T1.income  
 FROM Graduates T1, Graduates T2  
 GROUP BY T1.income  
 --S1 的条件  
 HAVING SUM(CASE WHEN T2.income >= T1.income THEN 1 ELSE 0 END) >= COUNT(*) / 2  
 --S2 的条件  
 AND SUM(CASE WHEN T2.income <= T1.income THEN 1 ELSE 0 END) >= COUNT(*) / 2 ) TMP;  

  加上等号并不是为了清晰地分开子集 S1 和S2，而是为了让这 2个子集拥有共同部分。如果去掉等号，将条件改成“>COUNT(*)/2”，那么当元素个数为偶数时，S1 和 S2 就没有共同的元素了，也就无法求出中位数了  

  # 查询不包含 NULL 的集合  
COUNT 函数的使用方法有 COUNT(*) 和 COUNT( 列名 ) 两种，它们的区别有两个：第一个是性能上的区别；第二个是 COUNT(*) 可以用于 NULL， 而COUNT(列名 )与其他聚合函数一样，要先排除掉NULL的行再进行统计。第二个区别也可以这么理解：COUNT(*)查询的是所有行的数目，而COUNT(列名)查询的则不一定是。  

  -- 在对包含 NULL 的列使用时，COUNT(*) 和 COUNT( 列名 ) 的查询结果是不同的  
SELECT COUNT(*), COUNT(col_1)  
 FROM NullTbl;  

  Students  
student_id   dpt  sbmt_date  
a01     cheme  2020-12-03  
a03     boli   2019-03-04  
a05     hist     
a06     pham  2020-01-09  

  们需要从这张表里找出哪些学院的学生全部都提交了报告  

  -- 查询“提交日期”列内不包含 NULL 的学院 (1) ：使用 COUNT 函数  
SELECT dpt  
 FROM Students  
 GROUP BY dpt  
HAVING COUNT(*) = COUNT(sbmt_date);  

  使用 CASE 表达式也可以实现同样的功能，而且更加通用  
-- 查询“提交日期”列内不包含 NULL 的学院 (2) ：使用 CASE 表达式  
SELECT dpt  
 FROM Students  
 GROUP BY dpt  
HAVING COUNT(*) = SUM(CASE WHEN sbmt_date IS NOT NULL THEN 1 ELSE 0 END);  

  # 同时拥有，满足  
items  
item  
A  
B  
C  

   ShopItems  
 s1  A  
 s1  C  
 s2  A  
 s2  B  
 s2  C  
 s3  B  
 s4  A  
 s4  C  
 s4  D  
我们要查询的是囊括了表 Items 中所有商品的店铺   
例如在医疗领域查询同时服用多种药物的患者，或者从员工技术资料库里查询 UNIX 和 Oracle 两者都精通的程序员，等等  
-- 查询啤酒、纸尿裤和自行车同时在库的店铺 ：错误的 SQL 语句  
SELECT DISTINCT shop  
 FROM ShopItems  
 WHERE item IN (SELECT item FROM Items);  

  -- 查询啤酒、纸尿裤和自行车同时在库的店铺 ：正确的 SQL 语句  
SELECT SI.shop  
 FROM ShopItems SI, Items I  
 WHERE SI.item = I.item  
 GROUP BY SI.shop  
HAVING COUNT(SI.item) = (SELECT COUNT(item) FROM Items);  

  -- COUNT(I.item) 的值已经不一定是 3 了  
SELECT SI.shop, COUNT(SI.item), COUNT(I.item)  
 FROM ShopItems SI, Items I  
 WHERE SI.item = I.item  
 GROUP BY SI.shop;  

  # 以上算法，假如s4店多个D商品，就有问题了  
-- 精确关系除法运算 ：使用外连接和 COUNT 函数  
SELECT SI.shop  
 FROM ShopItems SI LEFT OUTER JOIN Items I  
 ON SI.item=I.item  
 GROUP BY SI.shop  
HAVING COUNT(SI.item) = (SELECT COUNT(item) FROM Items)　　-- 条件 1  
 AND COUNT(I.item) = (SELECT COUNT(item) FROM Items); -- 条件 2  
   
   
# 查出现在可以出勤的队伍  
 teams  
member team_id status  
a      1      ready  
b      1      not ready   
c      2      ready  
d      2      ready  
e      2      ready  
f      3      not ready  

  -- 用谓词表达全称量化命题  
SELECT team_id, member  
 FROM Teams T1  
 WHERE NOT EXISTS  
 (SELECT *  
 FROM Teams T2  
 WHERE T1.team_id = T2.team_id  
 AND status <> '待命' );  
   
“所有队员都处于待命状态”＝“不存在不处于待命状态的队员”  
-- 用集合表达全称量化命题 (1)  
SELECT team_id  
 FROM Teams  
 GROUP BY team_id  
HAVING COUNT(*) = SUM(CASE WHEN status = '待命'  
 THEN 1  
 ELSE 0 END);  
   
 -- 用集合表达全称量化命题 (2)  
SELECT team_id  
 FROM Teams  
 GROUP BY team_id  
HAVING MAX(status) = '待命'  
 AND MIN(status) = '待命';  
   
-- 列表显示各个队伍是否所有队员都在待命  
SELECT team_id,  
 CASE WHEN MAX(status) = '待命' AND MIN(status) = '待命'  
 THEN '全都在待命'  
 ELSE '队长！人手不够' END AS status  
 FROM Teams  
 GROUP BY team_id;   
   
 需要注意的是，条件移到 SELECT 子句后，查询可能就不会被数据库优化了，所以性能上相比HAVING子句的写法会差一些  
   
 Materials  
 center  receive_date  material  
 tokyo  2019-01-23  Fe  
 NY     2020-03-10  Al  
 Beijing 2020-12-09 Na  
 NY     2020-03-10  Al  
 要调查出存在重复材料的生产地  
   
 -- 选中材料存在重复的生产地  
SELECT center  
 FROM Materials  
 GROUP BY center  
HAVING COUNT(material) <> COUNT(DISTINCT material);  
   
 SELECT center,  
 CASE WHEN COUNT(material) <> COUNT(DISTINCT material) THEN '存在重复'  
 ELSE '不存在重复' END AS status  
 FROM Materials  
 GROUP BY center;  
   
 在数学中，通过 GROUP BY 生成的子集有一个对应的名字，叫作划分（partition）。它是集合论和群论中的重要概念，指的是将某个集合按照某种规则进行分割后得到的子集。这些子集相互之间没有重复的元素，而且它们的并集就是原来的集合。这样的分割操作被称为划分操作。  
   
 以上问题也可以通过将 HAVING 改写成 EXISTS 的方式来解决  
   
 -- 存在重复的集合 ：使用 EXISTS  
SELECT center, material  
 FROM Materials M1  
 WHERE EXISTS  
 (SELECT *  
 FROM Materials M2  
 WHERE M1.center = M2.center  
 AND M1.receive_date <> M2.receive_date  
 AND M1.material = M2.material);  
   
 相反地，如果想要查出不存在重复材料的生产地有哪些，只需要把 EXISTS 改写为 NOT EXISTS 就可以了  
   
# 寻找缺失的编号 ：升级版  
-- 如果有查询结果，说明存在缺失的编号 ：只调查数列的连续性  
SELECT '存在缺失的编号' AS gap  
 FROM SeqTbl  
HAVING COUNT(*) <> MAX(seq) - MIN(seq) + 1 ;  
   
 不论是否存在缺失的编号，都想要返回结果，那么只需要像下面这样把条件写到 SELECT里就可以了  
 -- 不论是否存在缺失的编号都返回一行结果  
SELECT CASE WHEN COUNT(*) = 0  
 THEN '表为空'  
 WHEN COUNT(*) <> MAX(seq) - MIN(seq) + 1  
 THEN '存在缺失的编号'  
 ELSE '连续' END AS gap  
 FROM SeqTbl;  
   
# 处理1缺失问题  
 -- 查找最小的缺失编号 ：表中没有 1 时返回 1  
SELECT CASE WHEN COUNT(*) = 0 OR MIN(seq) > 1 -- 最小值不是 1 时→返回 1  
 THEN 1  
 ELSE (SELECT MIN(seq +1) -- 最小值是1时→返回最小的缺失编号  
 FROM SeqTbl S1  
 WHERE NOT EXISTS  
 (SELECT *  
 FROM SeqTbl S2  
 WHERE S2.seq = S1.seq + 1)) END  
 FROM SeqTbl;  
   
   
 TestResults  
 student_id  class  sex  score  
 001        A      1     99  
 003        B      0     90  
 005        B      0     82  
 007        C      1     70  
 009        C      0     75  
   
 第1题：请查询出 75% 以上的学生分数都在 80 分以上的班级  
 SELECT class  
 FROM TestResults  
GROUP BY class  
 HAVING COUNT(*) * 0.75 <= SUM(CASE WHEN score >= 80  
 THEN 1  
 ELSE 0 END) ;  
   
 第2题：请查询出分数在 50 分以上的男生的人数比分数在 50 分以上的女生的人数多的班级  
 SELECT class  
 FROM TestResults  
GROUP BY class  
 HAVING SUM(CASE WHEN score >= 50 AND sex = '男'  
 THEN 1  
 ELSE 0 END) > SUM(CASE WHEN score >= 50 AND sex = '女'  
 THEN 1  
 ELSE 0 END) ;  
   
 第3题：请查询出女生平均分比男生平均分高的班级  
   
 -- 比较男生和女生平均分的 SQL 语句 (1)：对空集使用 AVG 后返回 0  
 SELECT class  
 FROM TestResults  
GROUP BY class  
 HAVING AVG(CASE WHEN sex = '男'  
 THEN score  
 ELSE 0 END) < AVG(CASE WHEN sex = '女'  
 THEN score  
 ELSE 0 END) ;  
   
 某班只有女生，空值或0值处理  
   
 -- 比较男生和女生平均分的 SQL 语句 (2)：对空集求平均值后返回 NULL  
 SELECT class  
 FROM TestResults  
GROUP BY class  
 HAVING AVG(CASE WHEN sex = '男'  
 THEN score  
 ELSE NULL END) < AVG(CASE WHEN sex = '女'  
 THEN score  
 ELSE NULL END) ;  
   
 ## 总结  
 用于调查集合性质的常用条件及其用途  
   
No 条件表达式 用途  
1 COUNT (DISTINCT col) = COUNT (col) col 列没有重复的值  
2 COUNT(*) = COUNT(col) col 列不存在 NULL  
3 COUNT(*) = MAX(col) col 列是连续的编号（起始值是 1）  
4 COUNT(*) = MAX(col) - MIN(col) + 1 col 列是连续的编号（起始值是任意整数）  
5 MIN(col) = MAX(col) col 列都是相同值，或者是 NULL  
6 MIN(col) * MAX(col) > 0 col 列全是正数或全是负数  
7 MIN(col) * MAX(col) < 0 col 列的最大值是正数，最小值是负数  
8 MIN(ABS(col)) = 0 col 列最少有一个是 0  
9 MIN(col - 常量 ) = - MAX(col - 常量 ) col 列的最大值和最小值与指定常量等距   
   
 下面是本节要点。  
1. 在 SQL 中指定搜索条件时，最重要的是搞清楚搜索的实体是集合还是集合的元素。  
2. 如果一个实体对应着一行数据 → 那么就是元素，所以使用 WHERE子句。  
3. 如果一个实体对应着多行数据 → 那么就是集合，所以使用 HAVING子句。  
4. HAVING 子句可以通过聚合函数（特别是极值函数）针对集合指定各种条件。  
5. 如果通过 CASE 表达式生成特征函数，那么无论多么复杂的条件都可以描述。  
6. HAVING 子句很强大  
   
   
   
   
   
   
   
   

      