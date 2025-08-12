WITH s1 AS (SELECT
	operator,
	ROW_NUMBER()OVER w AS row_number,
	item_no,
	height,
	AVG(height)OVER w AS avg_height,
	STDDEV(height)OVER w AS stddev_height
FROM manufacturing_parts
	WINDOW w AS (PARTITION BY operator
	ORDER BY item_no
	RANGE BETWEEN 4 PRECEDING AND CURRENT ROW)
),

s2 AS (SELECT item_no,
	(s1.avg_height + 3*(s1.stddev_height/SQRT(5)))AS ucl,
	(s1.avg_height - 3*(s1.stddev_height/SQRT(5)))AS lcl
FROM s1
),

s3 AS (SELECT 
	operator,
	CASE 
	WHEN height NOT BETWEEN s2.lcl AND s2.ucl THEN TRUE 
	ELSE FALSE 
	END AS alert
FROM s1 INNER JOIN s2 USING (item_no)
WHERE row_number >=5
),

avg_op AS (SELECT 
	operator,
	ROUND(AVG(CASE WHEN alert THEN 1 ELSE 0 END),2) AS avg_op

FROM s3
GROUP BY operator
),
	
global_avg AS ( SELECT 
	ROUND(AVG(alert::int),2) AS global_avg
FROM s3
)

SELECT 
	operator,
	avg_op,
	global_avg
FROM avg_op CROSS JOIN global_avg
WHERE avg_op >global_avg
ORDER BY operator