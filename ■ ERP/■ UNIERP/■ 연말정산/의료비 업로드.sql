/*
�Ƿ��
*/

INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,RESID,NAME,SUM) 
 SELECT '20180013', --�����ȣ
 'B101Y', --����
 '9510142588025', --�ֹε�Ϲ�ȣ
 '�̰���', --����
38400 UNION ALL --�ݾ�
 SELECT '20180013', --�����ȣ
 'B101Y', --����
 '9510142588025', --�ֹε�Ϲ�ȣ
 '�̰���', --����
24000 UNION ALL --�ݾ�
 SELECT '20180013', --�����ȣ
 'B101Y', --����
 '9510142588025', --�ֹε�Ϲ�ȣ
 '�̰���', --����
84000 --�ݾ�
 INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,RESID,NAME,SUM) 
 SELECT '20180013', --�����ȣ
 'B101Y', --����
 '9510142588025', --�ֹε�Ϲ�ȣ
 '�̰���', --����
4700000 --�ݾ�
 INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,RESID,NAME,SUM) 
 SELECT '20180013', --�����ȣ
 'B101Y', --����
 '9510142588025', --�ֹε�Ϲ�ȣ
 '�̰���', --����
14200 UNION ALL --�ݾ�
 SELECT '20180013', --�����ȣ
 'B101Y', --����
 '9510142588025', --�ֹε�Ϲ�ȣ
 '�̰���', --����
94000 --�ݾ�
 INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,RESID,NAME,SUM) 
 SELECT '20180013', --�����ȣ
 'B101Y', --����
 '9510142588025', --�ֹε�Ϲ�ȣ
 '�̰���', --����
96800 --�ݾ�
 INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,RESID,NAME,SUM) 
 SELECT '20180013', --�����ȣ
 'B101Y', --����
 '9510142588025', --�ֹε�Ϲ�ȣ
 '�̰���', --����
6600 --�ݾ�
 INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,RESID,NAME,SUM) 
 SELECT '20180013', --�����ȣ
 'B101Y', --����
 '9510142588025', --�ֹε�Ϲ�ȣ
 '�̰���', --����
484000 --�ݾ�
 EXEC USP_H_UPLOAD_YEAREND_2 '2019','20180013' 
 DELETE FROM H_HFA_TEMP_TABLE WHERE EMP_NO = '20180013' 


 USP_H_UPLOAD_YEAREND_2


 sp_helptext 'USP_H_UPLOAD_YEAREND_8'