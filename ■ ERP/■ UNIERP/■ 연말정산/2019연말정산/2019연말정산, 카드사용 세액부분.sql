select FAMILY_NAME, USE_AMT, USE_TYPE, B.MINOR_NM
From HFA180T A JOIN B_MINOR B ON A.USE_TYPE = B.MINOR_CD  AND B.MAJOR_CD = 'H0138'
where emp_no = '20100003'
and year_yy = '2019'


-56430.0000


select SUM(USE_AMT)
From HFA180T
where emp_no = '20060007'
and year_yy = '2019'

select EMP_NO, SUM(USE_AMT) --신용카드
from HFA180T
where emp_no = '20060007'
and year_yy = '2019'
AND USE_TYPE IN ('1')
GROUP BY EMP_NO


select EMP_NO, SUM(USE_AMT) --직불카드등
from HFA180T  
where emp_no = '20060007'
and year_yy = '2019'
AND USE_TYPE IN ('6')
GROUP BY EMP_NO

select EMP_NO, SUM(USE_AMT) --현금영수증
from HFA180T  
where emp_no = '20060007'
and year_yy = '2019'
AND USE_TYPE IN ('2')
AND USE_TYPE NOT IN ('7','8','9','a','B','c','j','k') --전통시장, 대중교통 
GROUP BY EMP_NO


select EMP_NO, SUM(USE_AMT) --전통시장 사용
from HFA180T  
where emp_no = '20060007'
and year_yy = '2019'
AND USE_TYPE IN ('7','8','9')
GROUP BY EMP_NO

select EMP_NO, SUM(USE_AMT) --대중교통이용
from HFA180T  
where emp_no = '20060007'
and year_yy = '2019'
AND USE_TYPE IN ('A', 'B','C')
GROUP BY EMP_NO



--sp_helptext 'usp_h_yearEND_hometax'

--/*신용카드 등 사용금액 산출과정*/
--SELECT *
--FROM HFA181T
--where emp_no = '20060007'
--and year_yy = '2019'


select SUM(USE_AMT)
from HFA180T  
where emp_no = '20060007'
and year_yy = '2019'
AND USE_TYPE IN ('2')
AND USE_TYPE NOT IN ('8','B') --전통시장, 대중교통 


SELECT 15593060.0000 - 15649490


-56430.0000


select SUM(USE_AMT)

from HFA180T  
where emp_no = '20060007'
and year_yy = '2019'


--39916708.0000



sp_helptext 'usp_h_calc_pension_2019'

SELECT EXCEPT_AMT'공제제외금액', SUB_TEMP_AMT '공제가능금액', MIN_AMT '최저사용금액',SUB_TOT_AMT '최종공제금액',
 SUB1_AMT '일반공제금액',SUB2_AMT '추가공제금액1', SUB3_AMT '추가공제금액2', (SUB2_AMT + sub3_amt) '추가공제금액합' 
 ,MARKET_SUB_AMT '[사]전통시장 40공제액', TRANS_SUB_AMT '[아]교통비 40공제액', CASH_SUB_AMT '[다]현금영수증 30퍼 공제액',
 CARD_SUB_AMT '[가]신용카드 15퍼 공제액', DEBIT_SUB_AMT '[나]직불카드 30공제액', BOOK_SUB_AMT'[라,마,바]도서공연비30' ,INCOME_TOT_AMT '총급여'
 ,* --전통시장, 교통비, 현금영수증 등등 있는 테이블  
FROM HFA181T
where emp_no = '20090127'
and year_yy = '2019'


/*
HFA181T.SUB_TEMP_AMT 공제가능금액 산출하는 식에서 , 공제제외금액 EXCEPT_AMT 는 맞는데 그 앞부분 식 확인해보기 
*/


 sp_helptext 'usp_h_calc_etc_card_use'


 SUB_TEMP_AMT

 Select object_name(id) From syscomments Where text like '%SUB_TEMP_AMT%'
Group by object_name(id)
Order by object_name(id)


usp_h_calc_etc_card_use
