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
SELECT  '1' SUB_TYPE, A.EMP_NO , 'S13' ,기숙사사용료, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM,  NULL CALCU_TYPE,
'ADMIN', GETDATE(), 'ADMIN', GETDATE()
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 기숙사사용료 IS NOT NULL


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
SELECT  '1' SUB_TYPE, A.EMP_NO , 'S11' ,로인부양, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM,  NULL CALCU_TYPE,
'ADMIN', GETDATE(), 'ADMIN', GETDATE()
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 로인부양 IS NOT NULL



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
SELECT  '1' SUB_TYPE, A.EMP_NO , 'S08' ,자녀교육, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM,  NULL CALCU_TYPE,
'ADMIN', GETDATE(), 'ADMIN', GETDATE()
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 자녀교육 IS NOT NULL



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
SELECT  '1' SUB_TYPE, A.EMP_NO , 'S09' ,주택대출이자, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM,  NULL CALCU_TYPE,
'ADMIN', GETDATE(), 'ADMIN', GETDATE()
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 주택대출이자 IS NOT NULL





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
SELECT  '1' SUB_TYPE, A.EMP_NO , 'S10' ,주택임대료, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM,  NULL CALCU_TYPE,
'ADMIN', GETDATE(), 'ADMIN', GETDATE()
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 주택임대료 IS NOT NULL


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
SELECT  '1' SUB_TYPE, A.EMP_NO , 'S12' ,교육연수, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM,  NULL CALCU_TYPE,
'ADMIN', GETDATE(), 'ADMIN', GETDATE()
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 교육연수 IS NOT NULL


