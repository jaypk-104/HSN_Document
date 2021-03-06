/*
A_ACCT				전표계정
A_ACCT_CTRL_ASSN	전표계정별 관리항목
*/


SELECT *
FROM A_TEMP_GL
WHERE TEMP_GL_NO = 'TG202002270033'

SELECT *
FROM A_TEMP_GL_ITEM
WHERE TEMP_GL_NO = 'TG202002270033'

SELECT *
FROM A_ACCT
WHERE ACCT_NM LIKE '%업무가불%' --계정코드확인


BEGIN TRAN
UPDATE A_TEMP_GL_ITEM
SET ACCT_CD = '1111001' -- 변경후
WHERE TEMP_GL_NO = 'TG202002270034'
AND ITEM_SEQ = '2'      -- 변경전



INSERT INTO A_TEMP_GL_DTL(TEMP_GL_NO        ,ITEM_SEQ       ,DTL_SEQ      ,CTRL_CD            
                          ,CTRL_VAL     ,INSRT_USER_ID  ,INSRT_DT     ,UPDT_USER_ID    , UPDT_DT)      
--======= !! 
SELECT 'TG202002270034',2,CTRL_ITEM_SEQ,CTRL_CD,      
    '',     
      'admin',GETDATE(),'admin',GETDATE()      
  FROM A_ACCT_CTRL_ASSN(NOLOCK)      
  WHERE ACCT_CD = '1111001'      
  ORDER BY CTRL_ITEM_SEQ  