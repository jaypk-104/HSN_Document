/*
MRO ��������, ����BL����ϴ� �������� ���������� ��û
Q1. �̹� ��ε� ���� Ȯ����Ұ� �ȵɶ�
Q2. ��� �����ϰ� �ٽ� ����ϰ������

1. ���1 m_purchase_charge 
2. ���2 M_PURCHASE_EXPENSE_BY_ITEM -- TOT_MVMT_QTY , TOT_DISB_AMT  0���� ������Ʈ
3. ���3 M_PURCHASE_EXPENSE_BY_GM   -- ������ ���� 
4. ������ ���� ����, �����԰���(M4111MA1_S) [�����й�] ��ư Ŭ�� !! (����ڿ��� ����)
*/

select *
from m_purchase_charge
where bas_no = 'VL20190429001'

select *
from M_PURCHASE_EXPENSE_BY_ITEM
where charge_no in (
select charge_no
from m_purchase_charge
where bas_no = 'VL20190429001'

)
select *
from M_PURCHASE_EXPENSE_BY_gm
where charge_no in (
select charge_no
from m_purchase_charge
where bas_no = 'VL20190429001'
)


SELECT *
FROM M_PUR_GOODS_MVMT
WHERE MVMT_NO = 'PG20190530000109'

COMMIT

/*
2.
*/
BEGIN TRAN
UPDATE M_PURCHASE_EXPENSE_BY_ITEM
SET TOT_MVMT_QTY = 0,
TOT_DISB_AMT = 0
WHERE CHARGE_NO = 'VC20190603012'


/*
3.
*/
BEGIN TRAN
DELETE FROM M_PURCHASE_EXPENSE_BY_GM
WHERE CHARGE_NO = 'VC20190603012'

BEGIN TRAN
UPDATE M_PURCHASE_EXPENSE_BY_ITEM
SET TOT_MVMT_QTY = 0,
TOT_DISB_AMT = 0
WHERE CHARGE_NO = 'VC20190603012'

/*
4. ������ => �����԰��� => �����й� Ŭ�� ��, �Ʒ��� �ݾ�Ȯ��
*/

SELECT MVMT_NO, SUM(DISB_AMT)DISB_AMT
FROM M_PURCHASE_EXPENSE_BY_GM
WHERE MVMT_NO = 'PG20200504000003'
GROUP BY MVMT_NO

SELECT GM_NO, MVMT_RCPT_NO, MVMT_NO, SUM(DISTRIBT_AMT)DISB_AMT
FROM M_PUR_GOODS_MVMT
WHERE MVMT_NO = 'PG20200504000003'
GROUP BY GM_NO, MVMT_RCPT_NO, MVMT_NO


