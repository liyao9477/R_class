## CASE ----
-- 把县编号转换成地区编号 (2) ：将 CASE 表达式归纳到一处
SELECT CASE pref_name
WHEN '德岛' THEN '四国'
WHEN '香川' THEN '四国'
WHEN '爱媛' THEN '四国'
WHEN '高知' THEN '四国'
WHEN '福冈' THEN '九州'
WHEN '佐贺' THEN '九州'
WHEN '长崎' THEN '九州'
ELSE '其他' END AS district,
SUM(population)
FROM PopTbl
GROUP BY district;

事实上，在 Oracle、DB2、SQL Server 等数据库里采用这种写法时就会出错。
不过也有支持这种 SQL 语句的数据库，例如在 PostgreSQL 和 MySQL中，这个查询语句就可以顺利执行

## 举例2
province  sex population         -->          province    男    女
shanghai   1   600                           shanghai    600    400
shanghai   2   400 

SELECT province,
SUM(CASE WHEN sex = '1' THEN population ELSE 0 END) AS cnt_m, 
SUM(CASE WHEN sex = '2' THEN population ELSE 0 END) AS cnt_f 
FROM PopTbl2
GROUP BY province;

"新手用 WHERE 子句进行条件分支，高手用 SELECT 子句进行条件分支。"

# 举例3
Salaries
name  salary
lishi  72000
wangpeng 85000
liudan   90000
假设现在需要根据以下条件对该表的数据进行更新。
1. 对当前工资为 8 万元以上的员工，降薪 10%。
2. 对当前工资为 7 万元以上且不满 7.5 万元的员工，加薪 20%。
如果两步update，第一次update的结果，可能会影响第二次update

-- 用 CASE 表达式写正确的更新操作
UPDATE Salaries
SET salary = CASE WHEN salary >= 80000
THEN salary * 0.9
WHEN salary >= 70000 AND salary < 75000
THEN salary * 1.2
ELSE salary END;

# 举例4
SELECT std_id,
CASE WHEN COUNT(*) = 1 -- 只加入了一个社团的学生
THEN MAX(club_id)
ELSE MAX(CASE WHEN main_club_flg = 'Y'
         THEN club_id
         ELSE NULL END)
END AS main_club
FROM StudentClub
GROUP BY std_id;

"新手用HAVING子句进行条件分支，高手用SELECT子句进行条件分支。"


## 自连接 ----

“面向对象语言以对象的方式来描述世界，而面向集合语言 SQL 以集合的方式来描述世界。自连接技术充分体现了 SQL 面向集合的特性”
# 举例1
Products
name  price
apple  3.8
cherry 25.9
orange 8.5

要获取这些商品的组合
样通过交叉连接生成笛卡儿积（直积），就可以得到有序对 A。
-- 用于获取可重排列的 SQL 语句
SELECT P1.name AS name_1, P2.name AS name_2
 FROM Products P1, Products P2;

-- 用于获取排列的 SQL 语句
SELECT P1.name AS name_1, P2.name AS name_2
 FROM Products P1, Products P2
 WHERE P1.name <> P2.name;

-- 用于获取组合的 SQL 语句 ：扩展成 3 列
SELECT P1.name AS name_1, P2.name AS name_2, P3.name AS name_3
 FROM Products P1, Products P2, Products P3
 WHERE P1.name > P2.name
 AND P2.name > P3.name;

如这道例题所示，使用等号“＝”以外的比较运算符，如“<、>、<>”进行的连接称为“非等值连接”。这里将非等值连接与自连接结合使用了，因此称为“非等值自连接”。

# 举例2
下使用关联子查询删除重复行的方法
-- 用于删除重复行的 SQL 语句 (1) ：使用极值函数
DELETE FROM Products P1
 WHERE rowid < ( SELECT MAX(P2.rowid)
 FROM Products P2
 WHERE P1.name = P2. name
 AND P1.price = P2.price ) ;
请像前面的例题里讲过的一样，将关联子查询理解成对两个拥有相同数据的集合进行的关联操作

-- 用于删除重复行的 SQL 语句 (2) ：使用非等值连接
DELETE FROM Products P1
 WHERE EXISTS ( SELECT *
 FROM Products P2
 WHERE P1.name = P2.name
 AND P1.price = P2.price
 AND P1.rowid < P2.rowid );

# 举例3
查找局部不一致的列
查找是同一家人但住址却不同的记录
实现办法有几种，不过如果用非等值自连接来实现，代码会非常简洁。
-- 用于查找是同一家人但住址却不同的记录的 SQL 语句
SELECT DISTINCT A1.name, A1.address
 FROM Addresses A1, Addresses A2
 WHERE A1.family_id = A2.family_id
 AND A1.address <> A2.address ;

从张商品表里找出价格相等的商品的组合。
-- 用于查找价格相等但商品名称不同的记录的 SQL 语句
SELECT DISTINCT P1.name, P1.price
 FROM Products P1, Products P2
 WHERE P1.price = P2.price
 AND P1.name <> P2.name;

# 举例4
排序
-- 排序 ：使用窗口函数
SELECT name, price,
 RANK() OVER (ORDER BY price DESC) AS rank_1,
 DENSE_RANK() OVER (ORDER BY price DESC) AS rank_2
 FROM Products;
不过用到的 RANK 函数还属于标准 SQL 中较新的功能，目前只有个别数据库实现了它，还不能用于 MySQL 数据库

不依赖于具体数据库来实现的方法
-- 排序从 1 开始。如果已出现相同位次，则跳过之后的位次
SELECT P1.name,
 P1.price,
 (SELECT COUNT(P2.price)
 FROM Products P2
 WHERE P2.price > P1.price) + 1 AS rank_1
 FROM Products P1
 ORDER BY rank_1;
这段代码的排序方法看起来很普通，但很容易扩展。例如去掉标量子查询后边的 +1，就可以从 0 开始给商品排序，而且如果修改成
COUNT(DISTINCT P2.price)，那么存在相同位次的记录时，就可以不跳过之后的位次，而是连续输出（相当于 DENSE_RANK函数）。由此可知，这条 SQL 语句可以根据不同的需求灵活地进行扩展，实现不同的排序方式。

这个子查询的代码还可以像下面这样按照自连接的写法来改写。
-- 排序 ：使用自连接
SELECT P1.name,
 MAX(P1.price) AS price, 
 COUNT(P2.name) +1 AS rank_1
 FROM Products P1 LEFT OUTER JOIN Products P2
 ON P1.price < P2.price
 GROUP BY P1.name
 ORDER BY rank_1;
如果将外连接改为内连接看一看，马上就会明白这样做的原因。（将会排除最大的记录）
-- 排序 ：改为内连接
SELECT P1.name,
 MAX(P1.price) AS price, 
 COUNT(P2.name) +1 AS rank_1
 FROM Products P1 INNER JOIN Products P2
 ON P1.price < P2.price
 GROUP BY P1.name
 ORDER BY rank_1;


























