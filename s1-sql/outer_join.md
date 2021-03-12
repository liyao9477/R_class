# outer join
## 行转列
courses  
name course  
A    Chinese  
B    English  
C    Chemycal  
D    Boilygy  

-->  
    Chinese   English   Chemycal  
A     1         0         0  

-- 水平展开求交叉表 (1)：使用外连接  
SELECT C0.name,  
 CASE WHEN C1.name IS NOT NULL THEN '○' ELSE NULL END AS "SQL 入门",  
 CASE WHEN C2.name IS NOT NULL THEN '○' ELSE NULL END AS "UNIX 基础",  
 CASE WHEN C3.name IS NOT NULL THEN '○' ELSE NULL END AS "Java 中级"  
 FROM (SELECT DISTINCT name FROM Courses) C0   -- 这里的 C0 是侧栏  
 LEFT OUTER JOIN  
 (SELECT name FROM Courses WHERE course = 'SQL 入门' ) C1  
 ON C0.name = C1.name  
 LEFT OUTER JOIN  
 (SELECT name FROM Courses WHERE course = 'UNIX 基础' ) C2  
 ON C0.name = C2.name  
 LEFT OUTER JOIN  
 (SELECT name FROM Courses WHERE course = 'Java 中级' ) C3  
 ON C0.name = C3.name;  

因为目标表格的表头是 3列，所以进行了3次外连接。列数增加时原理也是一样的，只需要增加外连接操作就可以了。想生成置换了表头和表侧栏的交叉表时，我们也可以用同样的思路  

-- 水平展开 (2)：使用标量子查询  
SELECT C0.name,  
 (SELECT '○'  
 FROM Courses C1  
 WHERE course = 'SQL 入门'  
 AND C1.name = C0.name) AS "SQL 入门",  
 (SELECT '○'  
 FROM Courses C2  
 WHERE course = 'UNIX 基础'  
 AND C2.name = C0.name) AS "UNIX 基础",  
 (SELECT '○'  
 FROM Courses C3  
 WHERE course = 'Java 中级'  
 AND C3.name = C0.name) AS "Java 中级"  
 FROM (SELECT DISTINCT name FROM Courses) C0; -- 这里的 C0 是表侧栏  

这里的要点在于使用标量子查询来生成3列表头。最后一行FROM子句的集合C0和前面的“员工主表”是一样的缺点是性能不太好，目前在SELECT子句中使用标量子查询（或者关联子查询）的话，性能开销还是相当大的  

-- 水平展开 (3)：嵌套使用 CASE 表达式  
SELECT name,  
 CASE WHEN SUM(CASE WHEN course = 'SQL 入门' THEN 1 ELSE NULL END) = 1  
 THEN '○' ELSE NULL END AS "SQL 入门",  
 CASE WHEN SUM(CASE WHEN course = 'UNIX 基础' THEN 1 ELSE NULL END) = 1  
 THEN '○' ELSE NULL END AS "UNIX 基础",  
 CASE WHEN SUM(CASE WHEN course = 'Java 中级' THEN 1 ELSE NULL END) = 1  
 THEN '○' ELSE NULL END AS "Java 中级 "  
 FROM Courses  
 GROUP BY name;  

## 将列转行  
personnel  
employee  child_1  child_2  child_3  
Jim       A        B       C  
tom       C        D  
lisa      E  
cliff      
-- 列数据转换成行数据 ：使用 UNION ALL  
SELECT employee, child_1 AS child FROM Personnel  
UNION ALL  
SELECT employee, child_2 AS child FROM Personnel  
UNION ALL  
SELECT employee, child_3 AS child FROM Personnel;  

处理cliff的空数据  
CREATE VIEW Children(child)   
AS SELECT child_1 FROM Personnel  
 UNION  
 SELECT child_2 FROM Personnel  
 UNION  
 SELECT child_3 FROM Personnel;  

-- 获取员工子女列表的 SQL 语句（没有孩子的员工也要输出）  
SELECT EMP.employee, CHILDREN.child  
 FROM Personnel EMP  
 LEFT OUTER JOIN Children  
 ON CHILDREN.child IN (EMP.child_1, EMP.child_2, EMP.child_3);  

## 全外连接  
-- 数据库不支持全外连接时的替代方案  
SELECT A.id AS id, A.name, B.name  
 FROM Class_A A LEFT OUTER JOIN Class_B B  
 ON A.id = B.id  
 UNION  
SELECT B.id AS id, A.name, B.name  
 FROM Class_A A RIGHT OUTER JOIN Class_B B  
 ON A.id = B.id;  

在“不遗漏任何信息”这一点上，UNION 和全外连接非常相似（MERGE语句也是）  
用外连接求差集 ：A － B  
SELECT A.id AS id, A.name AS A_name  
 FROM Class_A A LEFT OUTER JOIN Class_B B  
 ON A.id = B.id  
 WHERE B.name IS NULL;  

用外连接求差集 ：B － A  
SELECT B.id AS id, B.name AS B_name  
 FROM Class_A A RIGHT OUTER JOIN Class_B B  
 ON A.id = B.id  
 WHERE A.name IS NULL;  

接下来我们考虑一下如何求两个集合的异或集。SQL没有定义求异或集的运算符，如果用集合运算符，可以有两种方法。一种是 (A UNION B) EXCEPT (A INTERSECT B)，另一种是 (A EXCEPT B) UNION (B EXCEPT A)。两种方法都比较麻烦，性能开销也会增大  

SELECT COALESCE(A.id, B.id) AS id,  
 COALESCE(A.name , B.name ) AS name  
 FROM Class_A A FULL OUTER JOIN Class_B B  
 ON A.id = B.id  
 WHERE A.name IS NULL   
 OR B.name IS NULL;  

-- 用外连接进行关系除法运算 ：差集的应用  
SELECT DISTINCT shop  
 FROM ShopItems SI1  
WHERE NOT EXISTS  
 (SELECT I.item   
 FROM Items I LEFT OUTER JOIN ShopItems SI2  
 ON I.item = SI2.item   
 AND SI1.shop = SI2.shop  
 WHERE SI2.item IS NULL) ;  








