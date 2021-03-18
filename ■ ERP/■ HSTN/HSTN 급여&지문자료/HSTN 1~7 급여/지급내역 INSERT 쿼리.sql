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
SELECT  A.EMP_NO, 'A02' ,근속수당, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 근속수당 IS NOT NULL


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
SELECT  A.EMP_NO, 'A03' ,개근수당, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 개근수당 IS NOT NULL

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
SELECT  A.EMP_NO, 'A04' ,기술수당, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 기술수당 IS NOT NULL

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
SELECT  A.EMP_NO, 'A05' ,직무수당, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 직무수당 IS NOT NULL

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
SELECT  A.EMP_NO, 'A06' ,직책수당, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 직책수당 IS NOT NULL

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
SELECT  A.EMP_NO, 'A07' ,특수수당, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 특수수당 IS NOT NULL



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
SELECT  A.EMP_NO, 'A30' ,평가수당, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 평가수당 IS NOT NULL

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
SELECT  A.EMP_NO, 'A22' ,ISNULL(잔업회수수당, 0) + 잔업수당, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 잔업수당 IS NOT NULL



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
SELECT  A.EMP_NO, 'A11' ,환경수당, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 환경수당 IS NOT NULL

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
SELECT  A.EMP_NO, 'A19' ,전화료, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 전화료 IS NOT NULL

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
SELECT  A.EMP_NO, 'A13' ,[감발/가장]*-1, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE [감발/가장] IS NOT NULL


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
SELECT  A.EMP_NO, 'A33' ,상월차액, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 상월차액 IS NOT NULL



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
SELECT  A.EMP_NO, 'A18' ,출장보조금, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 출장보조금 IS NOT NULL



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
SELECT  A.EMP_NO, 'A12' ,혹서수당, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE 혹서수당 IS NOT NULL