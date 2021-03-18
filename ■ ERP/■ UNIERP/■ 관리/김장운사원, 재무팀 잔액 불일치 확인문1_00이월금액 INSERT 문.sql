/*
usp_a_close_gl [결산마감및이월] 실행
연마감 X, 월마감 ㅇ
*/

--A_GL_SUM '00'
declare

 @conf_fg [nchar](1) = 1,  -- 1 : 이월  2 : 취소     @from_date [nchar](6),      
 @from_date [nchar](6) = '201912',      
 @to_date [nchar](6) = '202001',      
 @usr_id  [nvarchar](13)


 declare @fisc_end_dt  datetime,      
 @fisc_start_dt  datetime,      
 @next_yyyymm  [nvarchar](6)      

 --2110203
  SET @NEXT_YYYYMM = CONVERT([NVARCHAR](6),DATEADD(MONTH,1,CONVERT(DATETIME,@TO_DATE + '01')) ,112)  

   SELECT SUBSTRING(@NEXT_YYYYMM,1,4), SUBSTRING(@NEXT_YYYYMM,5,2), '00',       
  A.ACCT_CD, A.BIZ_AREA_CD, 'T',      
  SUM(A.DR_LOC_AMT), SUM(A.CR_LOC_AMT),      
  @USR_ID, GETDATE(), @USR_ID, GETDATE()      
  FROM A_GL_SUM A(NOLOCK)      
  WHERE SUBSTRING(A.FISC_YR + A.FISC_MNTH,1,6) >= @FROM_DATE      
  AND SUBSTRING(A.FISC_YR + A.FISC_MNTH,1,6) <= @TO_DATE      
  AND ( SUBSTRING(A.FISC_YR + A.FISC_MNTH,1,6) = @FROM_DATE       
  OR (SUBSTRING(A.FISC_YR + A.FISC_MNTH,1,6) <> @FROM_DATE AND A.FISC_DT <> '00') )      
  AND A.FISC_DT <> '99'      
  GROUP BY A.ACCT_CD, A.BIZ_AREA_CD      
  HAVING SUM(A.DR_LOC_AMT - A.CR_LOC_AMT) <> 0      
  ORDER BY A.ACCT_CD, A.BIZ_AREA_CD      
  


SELECT *
FROM A_GL_SUM
WHERE ACCT_CD = '1110104' 
AND FISC_YR = '2020'
AND FISC_MNTH = '03'
AND FISC_DT = '00'


UPDATE A_GL_SUM
SET CR_LOC_AMT = 86700323557.00
WHERE ACCT_CD = '1110104' 
AND FISC_YR = '2020'
AND FISC_MNTH = '03'
AND FISC_DT = '00'
/*

*/
-- A_SUBLEDGER_SUM '00'

declare

 @conf_fg [nchar](1) = 1,  -- 1 : 이월  2 : 취소     @from_date [nchar](6),      
     @from_date [nchar](6) = '202001',      
     @to_date [nchar](6) = '202002',      
     @usr_id  [nvarchar](13)


 declare @fisc_end_dt  datetime,      
 @fisc_start_dt  datetime,      
 @next_yyyymm  [nvarchar](6)      
  
  SET @NEXT_YYYYMM = CONVERT([NVARCHAR](6),DATEADD(MONTH,1,CONVERT(DATETIME,@TO_DATE + '01')) ,112)  


   SELECT SUBSTRING(@NEXT_YYYYMM,1,4), SUBSTRING(@NEXT_YYYYMM,5,2), '00',       
   A.ACCT_CD, A.BIZ_AREA_CD, A.CTRL_VAL1, A.CTRL_VAL2, 'T',      
    SUM(A.CR_LOC_AMT),SUM(A.DR_LOC_AMT),      
   @USR_ID, GETDATE(), @USR_ID, GETDATE()      
   FROM A_SUBLEDGER_SUM A(NOLOCK)      
   WHERE SUBSTRING(A.FISC_YR + A.FISC_MNTH,1,6) >= @FROM_DATE      
   AND SUBSTRING(A.FISC_YR + A.FISC_MNTH,1,6) <= @TO_DATE      
   AND ( SUBSTRING(A.FISC_YR + A.FISC_MNTH,1,6) = @FROM_DATE       
   OR (SUBSTRING(A.FISC_YR + A.FISC_MNTH,1,6) <> @FROM_DATE AND A.FISC_DT <> '00') )      
   AND A.FISC_DT <> '99'    
   GROUP BY A.ACCT_CD, A.BIZ_AREA_CD, A.CTRL_VAL1, A.CTRL_VAL2       
   HAVING SUM(A.DR_LOC_AMT - A.CR_LOC_AMT) <> 0      
   ORDER BY A.ACCT_CD, A.BIZ_AREA_CD  
  
  
  SELECT *
  FROM A_SUBLEDGER_SUM
  WHERE FISC_YR = '2020'
  AND FISC_MNTH = '03' 
  AND FISC_DT = '00'  
  AND ACCT_CD = '1110104'

