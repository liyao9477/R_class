# collection operation  
四则运算里的和（UNION）、差（EXCEPT）、积（CROSS JOIN）都被引入了标准SQL。但是很遗憾，商（DIVIDE BY）因为各种原因迟迟没能标准化  

检验集合相等  
SELECT COUNT(*) AS row_cnt
 FROM ( SELECT *
 FROM tbl_A
UNION
 SELECT *
 FROM tbl_B ) TMP;









