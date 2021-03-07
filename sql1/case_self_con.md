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








