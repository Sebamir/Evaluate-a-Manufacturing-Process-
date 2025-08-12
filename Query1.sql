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
)

SELECT 
	s1.operator,
	s1.row_number,
	s1.height,
	s1.avg_height,
	s1.stddev_height,
	s2.ucl,
	s2.lcl,
	CASE 
	WHEN height NOT BETWEEN s2.lcl AND s2.ucl THEN TRUE 
	ELSE FALSE 
	END AS alert
FROM s1 INNER JOIN s2 USING (item_no)
WHERE row_number >=5;