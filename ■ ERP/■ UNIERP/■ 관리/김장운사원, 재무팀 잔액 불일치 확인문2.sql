/*
1) A_SUBLEDGER_SUM - 보조부조회 잔액
*/
SELECT A.GL_DT, SUM(CR_LOC_AMT)CR_LOC_AMT, SUM(DR_LOC_AMT)DR_LOC_AMT
FROM A_SUBLEDGER A JOIN A_GL_ITEM B ON A.GL_NO = B.GL_NO AND A.ITEM_SEQ = B.ITEM_SEQ
WHERE A.GL_DT >= '20190401'
AND A.GL_DT <= '20190430'
AND A.CTRL_VAL1 = '04529'
AND B.ACCT_CD = '1110503'
GROUP BY A.GL_DT

SELECT FISC_YR + FISC_MNTH + FISC_DT, CR_LOC_AMT, DR_LOC_AMT
FROM A_SUBLEDGER_SUM
WHERE FISC_YR = '2019'
AND ACCT_CD = '1110503'
AND FISC_MNTH = '04'
AND FISC_DT >= '01'
AND FISC_DT <= '30'
AND CTRL_VAL1 = '04529'
ORDER BY FISC_DT


/*
2)A_GL_SUM에 이상이 있을때 - 월계정집계현황
*/
exec USP_A_RECALC_GL_SUM_KO512 '2020','',''

DECLARE @GL_DT_FR VARCHAR(30) = '2020-01-01'
DECLARE @GL_DT_TO VARCHAR(30) = '2020-08-30'

SELECT *
FROM (

 SELECT CONVERT(CHAR(8), A.GL_DT, 112) GL_DT, A.ACCT_CD, ISNULL(A.DR_LOC_AMT,0) DR_LOC_AMT , ISNULL(B.CR_LOC_AMT,0) CR_LOC_AMT
 FROM (
		SELECT B.GL_DT , B.ACCT_CD, B.DR_CR_FG, SUM(ITEM_LOC_AMT) DR_LOC_AMT
		FROM A_GL_ITEM B
		WHERE ACCT_CD IN (
'1110104'
		)
		AND B.DR_CR_FG = 'DR'
		AND B.GL_DT >= @GL_DT_FR
		AND B.GL_DT <= @GL_DT_TO
		GROUP BY B.GL_DT , B.ACCT_CD, B.DR_CR_FG
) A LEFT JOIN (

		SELECT CONVERT(CHAR(8), B.GL_DT, 112) GL_DT , B.ACCT_CD, B.DR_CR_FG, SUM(ITEM_LOC_AMT) CR_LOC_AMT 
		FROM A_GL_ITEM B
		WHERE ACCT_CD IN (
'1110104'
		)
		AND B.DR_CR_FG = 'CR'
		AND B.GL_DT >= @GL_DT_FR
		AND B.GL_DT <= @GL_DT_TO

		GROUP BY B.GL_DT , B.ACCT_CD, B.DR_CR_FG

) B ON A.GL_DT = B.GL_DT AND A.ACCT_CD = B.ACCT_CD ) AA LEFT JOIN (



	SELECT  d.fisc_yr+d.fisc_mnth+d.fisc_dt GL_DT , ACCT_CD, DR_LOC_AMT, CR_LOC_AMT
	fROM a_gl_sum D
	WHERE ACCT_CD LIKE '11101%'
	and ( 
	  d.fisc_yr+d.fisc_mnth+d.fisc_dt >= REPLACE(@GL_DT_FR,'-','')   
	 and d.fisc_yr+d.fisc_mnth+d.fisc_dt <= REPLACE(@GL_DT_TO,'-','')
	 and d.fisc_dt not in('00', '99')      
	 )    
 ) BB
 ON AA.GL_DT = BB.GL_DT AND AA.ACCT_CD = BB.ACCT_CD

AND AA.GL_DT >= REPLACE(@GL_DT_FR,'-','')   
AND AA.GL_DT <= REPLACE(@GL_DT_TO,'-','')

/*

*/
SELECT A.ACCT_CD,( A.DR + B.DR_LOC_AMT ), (A.CR + B.CR_LOC_AMT) 
FROM (
SELECT ACCT_CD , SUM(DR_LOC_AMT)DR ,SUM(CR_LOC_AMT)CR --무조건 고정 발생금액 (12~ 1월 총 두달 )
FROM A_GL_SUM
WHERE ACCT_CD = '1110104'
AND FISC_YR + FISC_MNTH + FISC_DT >= '20171201'
AND FISC_YR + FISC_MNTH + FISC_DT <= '20190630'
AND FISC_DT <> '00'
GROUP BY ACCT_CD
) A JOIN (
SELECT ACCT_CD,   DR_LOC_AMT, CR_LOC_AMT-- (12월에 이월금액 )
FROM A_GL_SUM
WHERE ACCT_CD = '1110104' 
AND FISC_YR = '2017'
AND FISC_MNTH = '12'
AND FISC_DT = '00'
) B  ON A.ACCT_CD = B.ACCT_CD



SELECT DR_LOC_AMT, CR_LOC_AMT-- (3월에 이월금액 )
FROM A_GL_SUM
WHERE ACCT_CD = '1110104' 
AND FISC_YR = '2019'
AND FISC_MNTH = '07'
AND FISC_DT = '00'

SELECT *
FROM A_GL_SUM
WHERE ACCT_CD = '1110104' 
AND FISC_YR = '2018'
--AND FISC_MNTH = '09'
AND FISC_DT = '00'

