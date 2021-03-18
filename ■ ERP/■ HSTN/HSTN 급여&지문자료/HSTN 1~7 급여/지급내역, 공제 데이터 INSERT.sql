--수당INSERT
/*
INSERT INTO [dbo].[HDF030T]
           ([EMP_NO]
           ,[ALLOW_CD]
           ,[ALLOW]
           ,[ALLOW_TYPE]
           ,[APPLY_YYMM]
           ,[REVOKE_YYMM]
           ,[ISRT_EMP_NO]
           ,[ISRT_DT]
           ,[UPDT_EMP_NO]
           ,[UPDT_DT]
           ,[PAY_MONTHS]
)
SELECT  A.EMP_NO, 'A19' ,전화료, 'Y' ALLOW_TYPE, '2020-02-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN02 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 전화료 IS NOT NULL


*/
--공제 INSERT
INSERT INTO [dbo].[HDF050T]
           ([SUB_TYPE]
           ,[EMP_NO]
           ,[SUB_CD]
           ,[SUB_AMT]
           ,[APPLY_YYMM]
           ,[REVOKE_YYMM]
           ,[CALCU_TYPE]
           ,[ISRT_EMP_NO]
           ,[ISRT_DT]
           ,[UPDT_EMP_NO]
           ,[UPDT_DT]
)
SELECT  '1' SUB_TYPE, A.EMP_NO , 'S11' ,로인부양, '2020-03-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM,  NULL CALCU_TYPE,
'ADMIN', GETDATE(), 'ADMIN', GETDATE()
FROM HSTN03 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 로인부양 IS NOT NULL


COMMIT
ROLLBACK
BEGIN TRAN
DELETE
fROM [HDF050T]


SELECT *
fROM HSTN02

SELECT *
FROM HAA010T
WHERE EMP_NO NOT IN (
SELECT *
FROM HDF040T
WHERE PAY_YYMM = '202002'
AND EMP_NO NOT IN (
SELECT EMP_NO 
FROM HAA010T
)
)
880008


declare @p10 nvarchar(6)
set @p10=NULL
declare @p11 nvarchar(60)
set @p11=NULL
exec usp_h_main_pay_calc @biz_area_cd=N'UB01',@pay_yymm=N'202002',@prov_type=N'1',@bas_dt_s=N'20200225',@prov_dt_s=N'20200225',@para_pay_cd=N'%',@para_emp_no=N'%',@li_yes=N'2',@usr_id=N'admin',@msg_cd=@p10 output,@msg_text=@p11 output
select @p10, @p11


HDF040T

SELECT *
fROM HSTN02


SELECT *
fROM HDA010T
WHERE