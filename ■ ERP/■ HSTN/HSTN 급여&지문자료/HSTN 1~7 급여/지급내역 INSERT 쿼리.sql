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
SELECT  A.EMP_NO, 'A02' ,�ټӼ���, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE �ټӼ��� IS NOT NULL


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
SELECT  A.EMP_NO, 'A03' ,���ټ���, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE ���ټ��� IS NOT NULL

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
SELECT  A.EMP_NO, 'A04' ,�������, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE ������� IS NOT NULL

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
SELECT  A.EMP_NO, 'A05' ,��������, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE �������� IS NOT NULL

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
SELECT  A.EMP_NO, 'A06' ,��å����, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE ��å���� IS NOT NULL

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
SELECT  A.EMP_NO, 'A07' ,Ư������, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE Ư������ IS NOT NULL



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
SELECT  A.EMP_NO, 'A30' ,�򰡼���, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE �򰡼��� IS NOT NULL

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
SELECT  A.EMP_NO, 'A22' ,ISNULL(�ܾ�ȸ������, 0) + �ܾ�����, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE �ܾ����� IS NOT NULL



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
SELECT  A.EMP_NO, 'A11' ,ȯ�����, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE ȯ����� IS NOT NULL

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
SELECT  A.EMP_NO, 'A19' ,��ȭ��, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE ��ȭ�� IS NOT NULL

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
SELECT  A.EMP_NO, 'A13' ,[����/����]*-1, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE [����/����] IS NOT NULL


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
SELECT  A.EMP_NO, 'A33' ,�������, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE ������� IS NOT NULL



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
SELECT  A.EMP_NO, 'A18' ,���庸����, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE ���庸���� IS NOT NULL



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
SELECT  A.EMP_NO, 'A12' ,Ȥ������, 'Y' ALLOW_TYPE, '2020-06-01' APPLY_YYMM, '2099-12-31' REVOKE_YYMM, 
'ADMIN', GETDATE(), 'ADMIN', GETDATE(), 0
FROM HSTN06 A JOIN HAA010T B ON A.EMP_NO = B.EMP_NO 
WHERE Ȥ������ IS NOT NULL