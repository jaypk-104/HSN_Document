select FAMILY_NAME, USE_AMT, USE_TYPE, B.MINOR_NM
From HFA180T A JOIN B_MINOR B ON A.USE_TYPE = B.MINOR_CD  AND B.MAJOR_CD = 'H0138'
where emp_no = '20100003'
and year_yy = '2019'


-56430.0000


select SUM(USE_AMT)
From HFA180T
where emp_no = '20060007'
and year_yy = '2019'

select EMP_NO, SUM(USE_AMT) --�ſ�ī��
from HFA180T
where emp_no = '20060007'
and year_yy = '2019'
AND USE_TYPE IN ('1')
GROUP BY EMP_NO


select EMP_NO, SUM(USE_AMT) --����ī���
from HFA180T  
where emp_no = '20060007'
and year_yy = '2019'
AND USE_TYPE IN ('6')
GROUP BY EMP_NO

select EMP_NO, SUM(USE_AMT) --���ݿ�����
from HFA180T  
where emp_no = '20060007'
and year_yy = '2019'
AND USE_TYPE IN ('2')
AND USE_TYPE NOT IN ('7','8','9','a','B','c','j','k') --�������, ���߱��� 
GROUP BY EMP_NO


select EMP_NO, SUM(USE_AMT) --������� ���
from HFA180T  
where emp_no = '20060007'
and year_yy = '2019'
AND USE_TYPE IN ('7','8','9')
GROUP BY EMP_NO

select EMP_NO, SUM(USE_AMT) --���߱����̿�
from HFA180T  
where emp_no = '20060007'
and year_yy = '2019'
AND USE_TYPE IN ('A', 'B','C')
GROUP BY EMP_NO



--sp_helptext 'usp_h_yearEND_hometax'

--/*�ſ�ī�� �� ���ݾ� �������*/
--SELECT *
--FROM HFA181T
--where emp_no = '20060007'
--and year_yy = '2019'


select SUM(USE_AMT)
from HFA180T  
where emp_no = '20060007'
and year_yy = '2019'
AND USE_TYPE IN ('2')
AND USE_TYPE NOT IN ('8','B') --�������, ���߱��� 


SELECT 15593060.0000 - 15649490


-56430.0000


select SUM(USE_AMT)

from HFA180T  
where emp_no = '20060007'
and year_yy = '2019'


--39916708.0000



sp_helptext 'usp_h_calc_pension_2019'

SELECT EXCEPT_AMT'�������ܱݾ�', SUB_TEMP_AMT '�������ɱݾ�', MIN_AMT '�������ݾ�',SUB_TOT_AMT '���������ݾ�',
 SUB1_AMT '�Ϲݰ����ݾ�',SUB2_AMT '�߰������ݾ�1', SUB3_AMT '�߰������ݾ�2', (SUB2_AMT + sub3_amt) '�߰������ݾ���' 
 ,MARKET_SUB_AMT '[��]������� 40������', TRANS_SUB_AMT '[��]����� 40������', CASH_SUB_AMT '[��]���ݿ����� 30�� ������',
 CARD_SUB_AMT '[��]�ſ�ī�� 15�� ������', DEBIT_SUB_AMT '[��]����ī�� 30������', BOOK_SUB_AMT'[��,��,��]����������30' ,INCOME_TOT_AMT '�ѱ޿�'
 ,* --�������, �����, ���ݿ����� ��� �ִ� ���̺�  
FROM HFA181T
where emp_no = '20090127'
and year_yy = '2019'


/*
HFA181T.SUB_TEMP_AMT �������ɱݾ� �����ϴ� �Ŀ��� , �������ܱݾ� EXCEPT_AMT �� �´µ� �� �պκ� �� Ȯ���غ��� 
*/


 sp_helptext 'usp_h_calc_etc_card_use'


 SUB_TEMP_AMT

 Select object_name(id) From syscomments Where text like '%SUB_TEMP_AMT%'
Group by object_name(id)
Order by object_name(id)


usp_h_calc_etc_card_use
