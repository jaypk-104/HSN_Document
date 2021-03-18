/*
철강팀 원가 금액 계산할때 (매출전표 원가계정) 총입고본수량과 총 출고수량이 같은 순간에는 마지막 출고수량이 M GR TO DN STEEL 에 INSERT 되기전에
매입금액 - 여태까지 원가금액(M_GR_TO_DN_STEEL.COG_GL_AMT 의 합계금액) 이 된금액이 마지막 출고수량의 COG_GL_AMT 에 INSERT 되야 한다.

그런 건들이 아닌건들의 원가금액 계산은

     SELECT BON_QTY, QTY, LOC_AMT, NVL(DISTR_AMT, 0)
                INTO   V_GR_BON_QTY, V_GR_QTY, V_LOC_AMT, V_DISTR_AMT
                FROM   M_GR_STEEL
                WHERE  COMP_ID  =V_COMP_ID
                AND    MVMT_NO  =V_MVMT_NO
                AND    MVMT_SEQ = V_MVMT_SEQ;


		  V_GL_COG_AMT:=ROUND((NVL(V_LOC_AMT, 0)+NVL(V_DISTR_AMT, 0))/V_GR_QTY*V_DN_QTY, 0);
		  총 매입금액 + 총 경비금액 / 총입고수량 * 해당 출고수량 된 금액으로 INSERT

		  총입고수량 = 총 출고수량이 같아지는 순간의 출고수량에 COG GL AMT 가 INSERT 되는거만 유의하면 된다 .

*/



SELECT A.MVMT_NO , A.MVMT_SEQ,  A.BON_QTY, B.DN_BON_QTY
FROM M_GR_STEEL A JOIN (SELECT MVMT_NO, MVMT_SEQ, SUM(DN_BON_QTY)DN_BON_QTY FROM M_GR_TO_DN_STEEL GROUP BY MVMT_NO, MVMT_SEQ ) B ON A.MVMT_NO = B.MVMT_NO AND A.MVMT_SEQ = B.MVMT_SEQ
JOIN M_GR_TO_DN_STEEL C ON A.MVMT_NO = C.MVMT_NO AND A.MVMT_SEQ = C.MVMT_SEQ
WHERE C.DN_DT >= '2020-03-01'



/*
철강팀 매출원가 계정
*/
SELECT BILL_NO, S_BP_CD, B.MVMT_NO,SUM(COG_GL_AMT)
FROM S_BILL_D_STEEL a JOIN M_GR_TO_DN_STEEL B ON A.DN_NO = B.DN_NO AND A.DN_SEQ = B.DN_SEQ
										 JOIN M_GR_STEEL C ON B.MVMT_NO = C.MVMT_NO AND B.MVMT_SEQ = C.MVMT_SEQ

WHERE BILL_NO = 'BN2020063000045'
GROUP BY BILL_NO, S_BP_CD, B.MVMT_NO



/*
고철, 매출 원가전표
*/
SELECT SUM(GR_AMT), M_BP_CD
FROM I_GOCHUL_IV_DN_MGM
WHERE IV_DN_NO IN(
SELECT a.DN_NO
FROM S_BILL_D_STEEL a
WHERE BILL_NO = 'BN2020061600003'
)GROUP BY M_BP_CD;

/*
BL기준
*/
SELECT SUM(D.DN_QTY),SUM(D.COG_GL_AMT)
FROM M_BL_HDR_STEEL AA JOIN  M_BL_DTL_STEEL A  ON AA.BL_NO = A.BL_NO
JOIN M_CC_DTL_STEEL B ON A.BL_NO = B.BL_NO AND A.BL_SEQ = B.BL_SEQ AND A.BL_SEQ2 = B.BL_SEQ2
JOIN M_GR_STEEL C ON B.CC_NO = C.CC_NO AND B.CC_SEQ = C.CC_SEQ AND B.CC_SEQ2 = C.CC_SEQ2
JOIN M_GR_TO_DN_STEEL D ON C.MVMT_NO = D.MVMT_NO AND C.MVMT_SEQ = D.MVMT_SEQ
WHERE AA.BL_DOC_NO = 'ASANVTPY-19-3501'
											AND D.DN_DT <= '2020-03-31'
											AND D.DN_DT >= '2020-01-01'


/*

*/

   SELECT   B.IV_TYPE, G.LC_DOC_NO, E.BL_DOC_NO, B.M_BP_CD, MAX(A.ITEM_CD) ITEM_CD, SUM(A.COG_GL_AMT) COG_GL_AMT,
                                  SUM(A.DN_QTY) DN_QTY, COUNT(A.ITEM_CD) ITEM_CNT,F.ITEM_CD ITEM_CD2
                         FROM     S_BILL_D_STEEL X
                                  INNER JOIN M_GR_TO_DN_STEEL A
                                  ON       X.COMP_ID=A.COMP_ID
                                  AND      X.DN_NO  =A.DN_NO
                                  AND      X.DN_SEQ =A.DN_SEQ
                                  LEFT OUTER JOIN M_GR_STEEL B
                                  ON       A.COMP_ID=B.COMP_ID
                                  AND      A.MVMT_NO=B.MVMT_NO
                                  AND 		 A.MVMT_SEQ=B.MVMT_SEQ
                                  LEFT OUTER JOIN M_CC_DTL_STEEL C
                                  ON       B.COMP_ID=C.COMP_ID
                                  AND      B.CC_NO  =C.CC_NO
                                  AND      B.CC_SEQ =C.CC_SEQ
                                  AND      B.CC_SEQ2=C.CC_SEQ2
                                  LEFT OUTER JOIN M_BL_DTL_STEEL D
                                  ON       C.COMP_ID=D.COMP_ID
                                  AND      C.BL_NO  =D.BL_NO
                                  AND      C.BL_SEQ =D.BL_SEQ
                                  AND 		C.BL_SEQ2=D.BL_SEQ2
                                  LEFT OUTER JOIN M_BL_HDR_STEEL E
                                  ON       D.COMP_ID=E.COMP_ID
                                  AND      D.BL_NO  =E.BL_NO
                                  LEFT OUTER JOIN M_LC_DTL_STEEL F
                                  ON       D.COMP_ID=F.COMP_ID
                                  AND      D.LC_NO  =F.LC_NO
                                  AND      D.LC_SEQ =F.LC_SEQ
                                  LEFT OUTER JOIN M_LC_HDR_STEEL G
                                  ON       F.COMP_ID=G.COMP_ID
                                  AND      F.LC_NO  =G.LC_NO
                         WHERE    B.IV_TYPE IN ('TO', 'PO', 'TB')
                         AND      X.COMP_ID =V_COMP_ID
                         AND      X.BILL_NO =V_BN_NO
                         GROUP BY G.LC_DOC_NO, E.BL_DOC_NO, B.IV_TYPE, B.M_BP_CD,F.ITEM_CD;





                         SELECT   B.IV_TYPE, '', C.BL_DOC_NO, B.M_BP_CD, MAX(A.ITEM_CD) ITEM_CD, SUM(A.COG_GL_AMT) COG_GL_AMT,
                                  SUM(A.DN_QTY) DN_QTY, COUNT(A.ITEM_CD) ITEM_CNT,SUBSTR(A.ITEM_CD,0,2) ITEM_CD2
                         FROM     S_BILL_D_STEEL X
                                 INNER JOIN M_GR_TO_DN_STEEL A
                                  ON       X.COMP_ID=A.COMP_ID
                                  AND      X.DN_NO  =A.DN_NO
                                  AND      X.DN_SEQ =A.DN_SEQ
                                  LEFT OUTER JOIN M_GR_STEEL B
                                  ON       A.COMP_ID=B.COMP_ID
                                  AND      A.MVMT_NO=B.MVMT_NO
                                  LEFT OUTER JOIN M_IV_D_STEEL C
                                  ON       B.COMP_ID=C.COMP_ID
                                  AND      B.MVMT_NO=C.MVMT_NO
                         WHERE    B.IV_TYPE IN ('DO')
                         AND      X.COMP_ID =V_COMP_ID
                         AND      X.BILL_NO =V_BN_NO
                         GROUP BY B.IV_TYPE, C.BL_DOC_NO, B.M_BP_CD,SUBSTR(A.ITEM_CD,0,2);





                    	SELECT 'DO' IV_TYPE,'',''BL_DOC_NO,M_BP_CD,'HS',SUM(GR_AMT),
                    	SUM(GR_KG),1,'HS'
                    	 FROM S_BILL_D_STEEL A INNER JOIN I_GOCHUL_IV_DN_MGM B
                    	ON A.DN_NO=B.IV_DN_NO
                    	WHERE A.BILL_NO=V_BN_NO
                    	GROUP BY M_BP_CD;





/*
원가금액 검증
*/
SELECT A.MVMT_NO, A.MVMT_SEQ, A.COG_AMT,A.COG_GL_AMT,ROUND(A.DN_QTY*PRC,0) FROM M_GR_TO_DN_STEEL A LEFT OUTER JOIN (
SELECT MVMT_NO,MVMT_SEQ,(LOC_AMT+NVL(DISTR_AMT,0))/QTY PRC FROM M_GR_STEEL
) B
ON A.MVMT_NO=B.MVMT_NO AND A.MVMT_SEQ=B.MVMT_SEQ
WHERE A.DN_DT>='2020-03-01'
AND A.COG_GL_AMT <> ROUND(A.DN_QTY*PRC,0) ;



SELECT ROUND((A.LOC_AMT + A.DISTR_AMT) / A.QTY * B.DN_QTY), B.COG_GL_AMT
FROM (SELECT MVMT_NO , MVMT_SEQ, SUM(LOC_AMT)LOC_AMT,SUM(QTY)QTY ,SUM(DISTR_AMT)DISTR_AMT FROM M_GR_STEEL GROUP BY MVMT_NO , MVMT_SEQ ) A JOIN M_GR_TO_DN_STEEL B ON A.MVMT_NO = B.MVMT_NO AND A.MVMT_SEQ = B.MVMT_SEQ
WHERE A.MVMT_NO = 'PG2020051500009'
AND B.DN_DT >= '2020-06-01'
AND B.DN_DT <= '2020-06-30'




MV20191024000046	8
MV20190830000128	5
MV20190830000128	23


SELECT QTY,LOC_AMT + DISTR_AMT
FROM M_GR_STEEL b
WHERE MVMT_NO = 'MV20190830000128'
AND MVMT_SEQ = 23;

--100411.2

SELECT SUM(DN_QTY), SUM(COG_GL_AMT)
FROM M_GR_TO_DN_STEEL b
WHERE MVMT_NO = 'MV20190830000128'
AND MVMT_SEQ= 23;


SELECT *
FROM S_BILL_D_STEEL a
WHERE DN_NO = 'DN20200320000064'
AND DN_SEQ =1


SELECT *
FROM M_BL_DTL_DISTR a
WHERE ROUND(LOC_AMT) <> LOC_AMT

SELECT TRUNC(LOC_AMT,3),A.*
FROM M_BL_DTL_DISTR a
WHERE BL_NO = 'VB2019041300001'

SELECT to_char(LOC_AMT, 'fm9999999999999.000') ,A.*
FROM M_BL_DTL_DISTR a
WHERE BL_NO = 'VB2019041300001'