/*
MRO 전경희사원, 수입BL등록하는 과정에서 경비수정관련 요청
Q1. 이미 배부된 경비라서 확정취소가 안될때
Q2. 경비 수정하고 다시 배분하고싶을때

1. 경비1 m_purchase_charge 
2. 경비2 M_PURCHASE_EXPENSE_BY_ITEM -- TOT_MVMT_QTY , TOT_DISB_AMT  0으로 업데이트
3. 경비3 M_PURCHASE_EXPENSE_BY_GM   -- 데이터 삭제 
4. 경비관련 수정 이후, 구매입고등록(M4111MA1_S) [경비재분배] 버튼 클릭 !! (사용자에게 전달)
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
4. 경비수정 => 구매입고등록 => 경비재분배 클릭 후, 아래의 금액확인
*/

SELECT MVMT_NO, SUM(DISB_AMT)DISB_AMT
FROM M_PURCHASE_EXPENSE_BY_GM
WHERE MVMT_NO = 'PG20200504000003'
GROUP BY MVMT_NO

SELECT GM_NO, MVMT_RCPT_NO, MVMT_NO, SUM(DISTRIBT_AMT)DISB_AMT
FROM M_PUR_GOODS_MVMT
WHERE MVMT_NO = 'PG20200504000003'
GROUP BY GM_NO, MVMT_RCPT_NO, MVMT_NO


