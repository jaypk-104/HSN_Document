
/*
세액 계산 쿼리 
*/


  SELECT
   CASE WHEN MAX(a.young_yn) = 'y' THEN '1' ELSE '' END  AS child_yn,
   ISNULL(SUM(USE_AMT1Y + BOOK_AMT_CARD_Y),0), a.emp_no  
        ,   c.YEAR_AREA_CD  
     , a.family_rel                 --7.관계  
     , a.nat_flag                  --8.내외국인구분코드 (내국인1, 외국인9)  
     , SUBSTRING(CONVERT(TEXT,REPLACE(a.family_name,' ','')),1,30) AS family_name  --9.성명  
     , RTRIM(REPLACE(a.family_res_no,'-',''))      AS family_res_no --10.주민등록번호  
     , CASE WHEN MAX(a.base_yn) = 'y' THEN '1' ELSE '' END   AS base_yn   --11.기본공제  
     --, ISNULL(a.paria_type,'')          AS paria_yn  --12.장애인공제  
     , CASE WHEN ISNULL(a.PARIA_YN,'N')='Y' THEN '1' ELSE '' END AS paria_yn  --12.장애인공제  
     , CASE WHEN MAX(a.lady_yn) = 'y' THEN '1' ELSE '' END   AS lady_yn   --13.부녀자공제  
     , CASE WHEN MAX(a.old_yn) = 'y' THEN '1' ELSE '' END   AS old_yn   --14.경로우대  
     , CASE WHEN MAX(a.single_yn) = 'y' THEN '1' ELSE '' END  AS single_yn  --15.한부모  
     , CASE WHEN MAX(a.childbirth_yn) = 'y' THEN '1' ELSE '' END AS childbirth_yn --16.출산/입양(#2014재정산)  
     , CASE WHEN MAX(a.young_yn) = 'y' THEN '1' ELSE '' END  AS child_yn  --17.6세이하(#2014재정산)  
	 , CASE WHEN ISNULL(SUM(edu_amty),0) + ISNULL(SUM(edu_amtn),0) > 0
			THEN (SELECT MIN(CASE WHEN FAMILY_TYPE = 'M' THEN '1' --본인
									   WHEN FAMILY_TYPE = '1' THEN '4' --대학생
									   WHEN FAMILY_TYPE = '2' THEN '3' --초.중.고등학교
									   WHEN FAMILY_TYPE = '5' THEN '2' --취학전 아동
									   ELSE '2' END) --장애인(장애인 재활교육비)
				  FROM HFA090T WHERE YY = '2019' AND EMP_NO = a.EMP_NO AND FAMILY_NAME = a.FAMILY_NAME)
			ELSE SPACE(1) END edu_type--18.교육비공제 2017추가
     --, ISNULL(SUM(insurey),0)          AS insur_amty  --건강,고용보험.  
     -- 국세청 건강, 고용보험료 지출금액  
     , ISNULL(SUM(0),0)           AS med_insur_amty  --19.건강
     , ISNULL(SUM(0),0)           AS emp_insur_amty  --20.고용보험  
     , ISNULL(SUM(othen_insur_amty),0)        AS othen_insur_amty --21.보장성보험료(장애인제외)(#2014재정산)  
     , ISNULL(SUM(disabled_insur_amty),0)       AS disabled_insur_amty --22.장애인전용보장성보험료(#2014재정산)  
  
     , ISNULL(SUM(med_amty),0)          AS med_amty  --23.의료비_일반  
     , ISNULL(SUM(med_amty_nanim),0)			AS med_amty_nanim  --24.의료비_난임
     , ISNULL(SUM(med_amty_paria),0)			AS med_amty_paria  --25.의료비_장애인.건강보험산정특례자
	 , ISNULL(SUM(medi_amty_silson),0)			AS medi_amty_silson /*2019년 귀속추가  26. 의료비_실손의료보험금 */
     , ISNULL(SUM(edu_amty),0)          AS edu_amty  --27.교육비_일반
     , ISNULL(SUM(edu_amty_paria),0)          AS edu_amty_paria  --28.교육비_장애인특수교육
     , ISNULL(CASE WHEN (SELECT INCOME_TOT_AMT FROM HFA050T(NOLOCK) WHERE EMP_NO = A.EMP_NO AND YEAR_YY = '2019') > 70000000 THEN ISNULL(SUM(USE_AMT1Y + BOOK_AMT_CARD_Y),0) ELSE ISNULL(SUM(USE_AMT1Y),0) END,0) AS use_amt1y  --29.신용카드  
     , ISNULL(CASE WHEN (SELECT INCOME_TOT_AMT FROM HFA050T(NOLOCK) WHERE EMP_NO = A.EMP_NO AND YEAR_YY = '2019') > 70000000 THEN ISNULL(SUM(DEBIT_AMTY + BOOK_AMT_CHECK_Y),0) ELSE ISNULL(SUM(DEBIT_AMTY),0) END,0) AS debit_amty  --30.직불선불  
     , ISNULL(CASE WHEN (SELECT INCOME_TOT_AMT FROM HFA050T(NOLOCK) WHERE EMP_NO = A.EMP_NO AND YEAR_YY = '2019') > 70000000 THEN ISNULL(SUM(USE_AMT2Y + BOOK_AMT_CASH_Y),0)	ELSE ISNULL(SUM(USE_AMT2Y),0) END,0) AS use_amt2y  --31.현금영수증  
     , ISNULL(CASE WHEN (SELECT INCOME_TOT_AMT FROM HFA050T(NOLOCK) WHERE EMP_NO = A.EMP_NO AND YEAR_YY = '2019') > 70000000 THEN 0 ELSE ISNULL(SUM(BOOK_AMT_CHECK_Y + BOOK_AMT_CARD_Y + BOOK_AMT_CASH_Y),0) END,0) AS book_amty  --32.도서.공연 사용분 
     , '0000000000'      space_1     --33. /*2019년 귀속추가*/
	 , ISNULL(SUM(market_amty),0)         AS market_amty  --34.전통시장  
     , ISNULL(SUM(trans_amty),0)         AS trans_amty  --35.대중교통  
     , ISNULL(SUM(contr_amty),0)         AS contr_amty  --36.기부금  
  
     -- 국세청외 건강, 고용보험료 지출금액  
     , CASE WHEN a.family_rel = '0' THEN ISNULL(SUM(0),0)  
                + ( SELECT ISNULL(SUM(hfa030t.med_insur),0)  
                FROM HFA030T  
                WHERE HFA030T.emp_no = a.emp_no  
                AND  HFA030T.yy  = '2019'  
                )  
                + ( SELECT ISNULL(SUM(hfa040t.a_med_insur),0) -- 20120202-193933 + hfa040t.a_emp_insur  2018년 건강,고용보험 분리
                FROM HFA040T  
                WHERE HFA040T.emp_no = a.emp_no  
                AND  HFA040T.year_yy = '2019'  
                )  
      ELSE ISNULL(SUM(0),0) END        AS med_insur_amtn  --37.건강
     , CASE WHEN a.family_rel = '0' THEN ISNULL(SUM(0),0)  
                + ( SELECT ISNULL(SUM(hfa030t.emp_insur),0)  
                FROM HFA030T  
                WHERE HFA030T.emp_no = a.emp_no  
                AND  HFA030T.yy  = '2019'  
                )  
                + ( SELECT ISNULL(SUM(hfa040t.a_emp_insur ),0) -- 20120202-193933 + hfa040t.a_emp_insur  2018년 건강,고용보험 분리
                FROM HFA040T  
                WHERE HFA040T.emp_no = a.emp_no  
                AND  HFA040T.year_yy = '2019'  
                )  
      ELSE ISNULL(SUM(0),0) END        AS emp_insur_amtn  --38.고용보험  
     , ISNULL(SUM(othen_insur_amtn),0)        AS othen_insur_amtn --39.보장성보험료(장애인제외)(#2014재정산)  
     , ISNULL(SUM(disabled_insur_amtn),0)       AS disabled_insur_amtn --40.장애인전용보장성보험료(#2014재정산)  
     , ISNULL(SUM(med_amtn),0)          AS med_amtn  --41.의료비_일반
     , ISNULL(SUM(med_amtn_nanim),0)			AS med_amtn2  --42.의료비_난임
     , ISNULL(SUM(med_amtn_paria),0)			AS med_amtn3  --43.의료비_장애인.건강보험산적특례자
     , ISNULL(SUM(medi_amtn_silson),0)			AS medi_amtn_silson  --44. 의료비_실손의료보험금
     , ISNULL(SUM(edu_amtn),0)          AS edu_amtn  --45.교육비_일반
     , ISNULL(SUM(edu_amtn_paria),0)         AS edu_amtn2  --46.교육비_장애인특수교육
     , ISNULL(CASE WHEN (SELECT INCOME_TOT_AMT FROM HFA050T(NOLOCK) WHERE EMP_NO = A.EMP_NO AND YEAR_YY = '2019') > 70000000 THEN ISNULL(SUM(USE_AMT1N + BOOK_AMT_CARD_N),0)	ELSE	ISNULL(SUM(USE_AMT1N),0) END,0)         AS use_amt1n  --47.신용카드  
     , ISNULL(CASE WHEN (SELECT INCOME_TOT_AMT FROM HFA050T(NOLOCK) WHERE EMP_NO = A.EMP_NO AND YEAR_YY = '2019') > 70000000 THEN ISNULL(SUM(DEBIT_AMTN + BOOK_AMT_CHECK_N),0)	ELSE	ISNULL(SUM(DEBIT_AMTN),0) END,0)        AS debit_amtn  --48.직불선불  
     , ISNULL(CASE WHEN (SELECT INCOME_TOT_AMT FROM HFA050T(NOLOCK) WHERE EMP_NO = A.EMP_NO AND YEAR_YY = '2019') > 70000000 THEN 0	ELSE	ISNULL(SUM(BOOK_AMT_CHECK_N + BOOK_AMT_CARD_N),0) END,0)         AS book_amtn  --49.도서.공연 사용분
     , '0000000000'      space_2   --50. 공란  
	 , ISNULL(SUM(market_amtn),0)       AS market_amtn  --51.전통시장  
     , ISNULL(SUM(trans_amtn),0)        AS trans_amtn  --52.대중교통  
     , ISNULL(SUM(contr_amtn),0)        AS contr_amtn  --53.기부금  
     , 'KO512' CO_CD  
    FROM hfa150t a 
      left outer JOIN (  
           --보험료 hfa170t ---------------------------
											/*2019년 귀속 medi_amty_silson, medi_amtn_silson 자료 추가함 */
											-- 2008.12 보험료 본인 국세청외자료 에 건강보험료+고용보험료 포함되어야함.
											SELECT	emp_no
												,	family_name
												,	family_rel
												,	dbo.ufn_getcodename('h0140',family_rel)	AS	family_rel_nm
												,	0										AS	nat_flag	--2007.04.17
												,	CASE WHEN insur_type = '1' THEN insur_amt ELSE 0 END AS	othen_insur_amty
												,	CASE WHEN insur_type = '2' THEN insur_amt ELSE 0 END AS	disabled_insur_amty
												,	0										AS	med_amty
												,	0										AS	med_amty_nanim
												,	0										AS	med_amty_paria
												,	0										AS	edu_amty
												,	0										AS	edu_amty_paria
												,	0										AS	use_amt1y
												,	0										AS	debit_amty
												,	0										AS	use_amt2y
												,	0										AS	market_amty
												,	0										AS	trans_amty
												,	0										AS	book_amt_card_y
												,	0										AS	book_amt_cash_y
												,	0										AS	book_amt_check_y
												,	0										AS	contr_amty
												,   0										AS	medi_amty_silson
												,	0										AS	othen_insur_amtn
												,	0										AS	disabled_insur_amtn
												,	0										AS	med_amtn
												,	0										AS	med_amtn_nanim
												,	0										AS	med_amtn_paria
												,	0										AS	edu_amtn
												,	0										AS	edu_amtn_paria
												,	0										AS	use_amt1n
												,	0										AS	debit_amtn
												,	0										AS	market_amtn
												,	0										AS	trans_amtn
												,	0										AS	book_amt_card_n
												,	0										AS	book_amt_cash_n
												,	0										AS	book_amt_check_n
												,	0										AS	contr_amtn
												,   0										AS	medi_amtn_silson
												,	'KO512'CO_CD
												
											FROM	hfa170t
											WHERE	year_yy		=	'2019'
											AND		year_flag	=	'y'
											AND		submit_flag	=	'y'
											UNION	ALL
											SELECT  emp_no
												,	family_name
												,	family_rel
												,	dbo.ufn_getcodename('h0140',family_rel)	AS	family_rel_nm
												,	0										AS	nat_flag	--2007.04.17
												,	0										AS	othen_insur_amty
												,	0										AS	disabled_insur_amty
												,	0										AS	med_amty
												,	0										AS	med_amty_nanim
												,	0										AS	med_amty_paria
												,	0										AS	edu_amty
												,	0										AS	edu_amty_paria
												,	0										AS	use_amt1y
												,	0										AS	debit_amty
												,	0										AS	use_amt2y
												,	0										AS	market_amty
												,	0										AS	trans_amty
												,	0										AS	book_amt_card_y
												,	0										AS	book_amt_cash_y
												,	0										AS	book_amt_check_y
												,	0										AS	contr_amty		
												,   0										AS	medi_amty_silson										
												,	CASE WHEN insur_type = '1' THEN insur_amt ELSE 0 END AS	othen_insur_amtn
												,	CASE WHEN insur_type = '2' THEN insur_amt ELSE 0 END AS	disabled_insur_amtn
												,	0										AS	med_amtn
												,	0										AS	med_amtn_nanim
												,	0										AS	med_amtn_paria
												,	0										AS	edu_amtn
												,	0										AS	edu_amtn_paria
												,	0										AS	use_amt1n
												,	0										AS	debit_amtn
												,	0										AS	market_amtn
												,	0										AS	trans_amtn
												,	0										AS	book_amt_card_n
												,	0										AS	book_amt_cash_n
												,	0										AS	book_amt_check_n
												,	0										AS	contr_amtn
												,   0										AS	medi_amtn_silson
												,	'KO512'CO_CD
												
											FROM	hfa170t
											WHERE	year_yy		=	'2019'
											AND		year_flag	=	'y'
											AND		submit_flag	<>	'y'
											--hfa150t---------------------------
											UNION	ALL
											SELECT  emp_no
													,family_name
													,family_rel
													,dbo.ufn_getcodename('h0140',family_rel) family_rel_nm 
													,0 nat_flag --2007.04.17
											        ,0 insurey
													,0 disabled_insur_amty
													,0 med_amty
													,0 med_amty_nanim
													,0 med_amty_paria
													,0 edu_amty
													,0 edu_amty_paria
													,0 use_amt1y
													,0 debit_amty
													,0 use_amt2y
													,0 market_amty
													,0 trans_amty
													,0 book_amt_card_y 
													,0 book_amt_cash_y 
													,0 book_amt_check_y 
													,0 gibuy
													,0 medi_amty_silson
											        ,0 insuren
													,0 disabled_insur_amtn
													,0 med_amtn
													,0 med_amtn_nanim
													,0 med_amtn_paria
													,0 edu_amtn
													,0 edu_amtn_paria
													,0 use_amt1n
													,0 debit_amtn
													,0 market_amtn
													,0 trans_amtn
													,0 book_amt_card_n 
													,0 book_amt_cash_n 
													,0 book_amt_check_n 
													,0 gibun
													,0 medi_amtn_silson

													, 'KO512'CO_CD													
											FROM    hfa150t
											WHERE   ( base_yn='y' or paria_yn='y' or child_yn='y') AND year_yy ='2019'
											UNION   ALL
											--의료비_국세청자료_일반 hfa130t ---------------------------
											SELECT  emp_no
												   ,family_nm
												   ,family_rel
												   ,dbo.ufn_getcodename('h0140',family_rel) family_rel_nm
												   ,0 nat_flag --2007.04.17
											       ,0 insurey
												   ,0 disabled_insur_amty
												   ,med_amt med_amty
												   ,0 med_amty_nanim
												   ,0 med_amty_paria
												   ,0 edu_amty
												   ,0 edu_amty_paria
												   ,0 use_amt1y
												   ,0 debit_amty
												   ,0 use_amt2y
												   ,0 market_amty
												   ,0 trans_amty
												   ,0 book_amt_card_y 
												   ,0 book_amt_cash_y 
												   ,0 book_amt_check_y 
												   ,0 gibuy
													,0 medi_amty_silson
											       ,0 insuren
												   ,0 disabled_insur_amtn
												   ,0 med_amtn
												   ,0 med_amtn_nanim
												   ,0 med_amtn_paria
												   ,0 edu_amtn
												   ,0 edu_amtn_paria
												   ,0 use_amt1n
												   ,0 debit_amtn
												   ,0 market_amtn
												   ,0 trans_amtn
												   ,0 book_amt_card_n 
												   ,0 book_amt_cash_n 
												   ,0 book_amt_check_n
												   ,0 gibun
												   ,0 medi_amtn_silson

												   , 'KO512'CO_CD													
											FROM    hfa130t  
											WHERE   year_yy     ='2019' AND year_flag='y' AND  submit_flag='y'
											and ISNULL(family_type,'') <> 'A' and med_type not in ('B06')

											UNION   ALL
											--의료비_국세청자료_난임 hfa130t ---------------------------
											SELECT  emp_no
												   ,family_nm
												   ,family_rel
												   ,dbo.ufn_getcodename('h0140',family_rel) family_rel_nm
												   ,0 nat_flag --2007.04.17
											       ,0 insurey
												   ,0 disabled_insur_amty
												   ,0 med_amty
												   ,med_amt med_amty_nanim
												   ,0 med_amty_paria
												   ,0 edu_amty
												   ,0 edu_amty_paria
												   ,0 use_amt1y
												   ,0 debit_amty
												   ,0 use_amt2y
												   ,0 market_amty
												   ,0 trans_amty
												   ,0 book_amt_card_y 
												   ,0 book_amt_cash_y 
												   ,0 book_amt_check_y  
												   ,0 gibuy
													,0 medi_amty_silson
											       ,0 insuren
												   ,0 disabled_insur_amtn
												   ,0 med_amtn
												   ,0 med_amtn_nanim
												   ,0 med_amtn_paria
												   ,0 edu_amtn
												   ,0 edu_amtn_paria
												   ,0 use_amt1n
												   ,0 debit_amtn
												   ,0 market_amtn
												   ,0 trans_amtn
												   ,0 book_amt_card_n 
												   ,0 book_amt_cash_n 
												   ,0 book_amt_check_n
												   ,0 gibun
												   ,0 medi_amtn_silson

												   , 'KO512'CO_CD													
											FROM    hfa130t  
											WHERE   year_yy     ='2019' AND year_flag='y' AND  submit_flag='y' and med_type = 'B06'
											UNION   ALL
											--의료비_국세청자료_장애인 hfa130t ---------------------------
											SELECT  emp_no
												   ,family_nm
												   ,family_rel
												   ,dbo.ufn_getcodename('h0140',family_rel) family_rel_nm
												   ,0 nat_flag --2007.04.17
											       ,0 insurey
												   ,0 disabled_insur_amty
												   ,0 med_amty
												   ,0 med_amty_nanim
												   ,med_amt med_amty_paria
												   ,0 edu_amty
												   ,0 edu_amty_paria
												   ,0 use_amt1y
												   ,0 debit_amty
												   ,0 use_amt2y
												   ,0 market_amty
												   ,0 trans_amty
												   ,0 book_amt_card_y 
												   ,0 book_amt_cash_y 
												   ,0 book_amt_check_y 
												   ,0 gibuy
													,0 medi_amty_silson

											       ,0 insuren
												   ,0 disabled_insur_amtn
												   ,0 med_amtn
												   ,0 med_amtn_nanim
												   ,0 med_amtn_paria
												   ,0 edu_amtn
												   ,0 edu_amtn_paria
												   ,0 use_amt1n
												   ,0 debit_amtn
												   ,0 market_amtn
												   ,0 trans_amtn
												   ,0 book_amt_card_n 
												   ,0 book_amt_cash_n 
												   ,0 book_amt_check_n 
												   ,0 gibun
												   ,0 medi_amtn_silson
												   , 'KO512'CO_CD													
											FROM    hfa130t  
											WHERE   year_yy     ='2019' AND year_flag='y' AND  submit_flag='y' and ISNULL(family_type,'') = 'A' and med_type not in ('B06')
											UNION   ALL
											--의료비_기타자료_일반 hfa130t ---------------------------
											SELECT  emp_no
												   ,family_nm
												   ,family_rel
												   ,dbo.ufn_getcodename('h0140',family_rel) family_rel_nm
												   ,0 nat_flag --2007.04.17
											       ,0 insurey
												   ,0 disabled_insur_amty
												   ,0 med_amty
												   ,0 med_amty_nanim
												   ,0 med_amty_paria
												   ,0 edu_amty
												   ,0 edu_amty_paria
												   ,0 use_amt1y
												   ,0 debit_amty
												   ,0 use_amt2y
												   ,0 market_amty
												   ,0 trans_amty
												   ,0 book_amt_card_y 
												   ,0 book_amt_cash_y 
												   ,0 book_amt_check_y  
												   ,0 gibuy
													,0 medi_amty_silson

											       ,0 insuren
												   ,0 disabled_insur_amtn
												   ,med_amt med_amtn
												   ,0 med_amtn_nanim
												   ,0 med_amtn_paria
												   ,0 edu_amtn
												   ,0 edu_amtn_paria
												   ,0 use_amt1n
												   ,0 debit_amtn
												   ,0 market_amtn
												   ,0 trans_amtn
												   ,0 book_amt_card_n 
												   ,0 book_amt_cash_n 
												   ,0 book_amt_check_n 
												   ,0 gibun
												   ,0 medi_amtn_silson
												   , 'KO512'CO_CD													
											FROM    hfa130t  
											WHERE   year_yy     ='2019' AND year_flag='y' AND  submit_flag<>'y'
											and ISNULL(family_type,'') <> 'A' and med_type not in ('B06','B99') --B99 실손의로보험 2019년귀속 추가 
											UNION   ALL
											--의료비_기타자료_실손의료보험 hfa130t ---------------------------/*2019년 귀속 추가*/
											SELECT  emp_no
												   ,family_nm
												   ,family_rel
												   ,dbo.ufn_getcodename('h0140',family_rel) family_rel_nm
												   ,0 nat_flag --2007.04.17
											       ,0 insurey
												   ,0 disabled_insur_amty
												   ,0 med_amty
												   ,0 med_amty_nanim
												   ,0 med_amty_paria
												   ,0 edu_amty
												   ,0 edu_amty_paria
												   ,0 use_amt1y
												   ,0 debit_amty
												   ,0 use_amt2y
												   ,0 market_amty
												   ,0 trans_amty
												   ,0 book_amt_card_y 
												   ,0 book_amt_cash_y 
												   ,0 book_amt_check_y  
												   ,0 gibuy
													,0 medi_amty_silson

											       ,0 insuren
												   ,0 disabled_insur_amtn
												   ,0 med_amtn
												   ,0 med_amtn_nanim
												   ,0 med_amtn_paria
												   ,0 edu_amtn
												   ,0 edu_amtn_paria
												   ,0 use_amt1n
												   ,0 debit_amtn
												   ,0 market_amtn
												   ,0 trans_amtn
												   ,0 book_amt_card_n 
												   ,0 book_amt_cash_n 
												   ,0 book_amt_check_n 
												   ,0 gibun
												   ,med_amt medi_amtn_silson
												   , 'KO512'CO_CD													
											FROM    hfa130t  
											WHERE   year_yy     ='2019' AND year_flag='y' AND  submit_flag<>'y'
											and ISNULL(family_type,'') <> 'A' and med_type in ('B99') --B99 실손의로보험 2019년귀속 추가 

											UNION   ALL
											--의료비_기타자료_실손의료보험 hfa130t ---------------------------/*2019년 귀속 추가*/
											SELECT  emp_no
												   ,family_nm
												   ,family_rel
												   ,dbo.ufn_getcodename('h0140',family_rel) family_rel_nm
												   ,0 nat_flag --2007.04.17
											       ,0 insurey
												   ,0 disabled_insur_amty
												   ,0 med_amty
												   ,0 med_amty_nanim
												   ,0 med_amty_paria
												   ,0 edu_amty
												   ,0 edu_amty_paria
												   ,0 use_amt1y
												   ,0 debit_amty
												   ,0 use_amt2y
												   ,0 market_amty
												   ,0 trans_amty
												   ,0 book_amt_card_y 
												   ,0 book_amt_cash_y 
												   ,0 book_amt_check_y  
												   ,0 gibuy
												   ,med_amt medi_amty_silson

											       ,0 insuren
												   ,0 disabled_insur_amtn
												   ,0 med_amtn
												   ,0 med_amtn_nanim
												   ,0 med_amtn_paria
												   ,0 edu_amtn
												   ,0 edu_amtn_paria
												   ,0 use_amt1n
												   ,0 debit_amtn
												   ,0 market_amtn
												   ,0 trans_amtn
												   ,0 book_amt_card_n 
												   ,0 book_amt_cash_n 
												   ,0 book_amt_check_n 
												   ,0 gibun
												   ,0 medi_amtn_silson
												   , 'KO512'CO_CD													
											FROM    hfa130t  
											WHERE   year_yy     ='2019' AND year_flag='y' AND  submit_flag='y'
											and ISNULL(family_type,'') <> 'A' and med_type in ('B99') --B99 실손의로보험 2019년귀속 추가 

											UNION   ALL
											--의료비_국세청자료_난임 hfa130t ---------------------------
											SELECT  emp_no
												   ,family_nm
												   ,family_rel
												   ,dbo.ufn_getcodename('h0140',family_rel) family_rel_nm
												   ,0 nat_flag --2007.04.17
											       ,0 insurey
												   ,0 disabled_insur_amty
												   ,0 med_amty
												   ,0 med_amty_nanim
												   ,0 med_amty_paria
												   ,0 edu_amty
												   ,0 edu_amty_paria
												   ,0 use_amt1y
												   ,0 debit_amty
												   ,0 use_amt2y
												   ,0 market_amty
												   ,0 trans_amty
												   ,0 book_amt_card_y 
												   ,0 book_amt_cash_y 
												   ,0 book_amt_check_y 
												   ,0 gibuy
													,0 medi_amty_silson

											       ,0 insuren
												   ,0 disabled_insur_amtn
												   ,0 med_amtn
												   ,med_amt med_amtn_nanim
												   ,0 med_amtn_paria
												   ,0 edu_amtn
												   ,0 edu_amty_paria
												   ,0 use_amt1n
												   ,0 debit_amtn
												   ,0 market_amtn
												   ,0 trans_amtn
												   ,0 book_amt_card_n 
												   ,0 book_amt_cash_n 
												   ,0 book_amt_check_n 
												   ,0 gibun
												   ,0 medi_amtn_silson
												   , 'KO512'CO_CD													
											FROM    hfa130t  
											WHERE   year_yy     ='2019' AND year_flag='y' AND  submit_flag<>'y' and med_type = 'B06'
											UNION   ALL
											--의료비_국세청자료_장애인 hfa130t ---------------------------
											SELECT  emp_no
												   ,family_nm
												   ,family_rel
												   ,dbo.ufn_getcodename('h0140',family_rel) family_rel_nm
												   ,0 nat_flag --2007.04.17
											       ,0 insurey
												   ,0 disabled_insur_amty
												   ,0 med_amty
												   ,0 med_amty_nanim
												   ,0 med_amty_paria
												   ,0 edu_amty
												   ,0 edu_amty_paria
												   ,0 use_amt1y
												   ,0 debit_amty
												   ,0 use_amt2y
												   ,0 market_amty
												   ,0 trans_amty
												   ,0 book_amt_card_y 
												   ,0 book_amt_cash_y 
												   ,0 book_amt_check_y 
												   ,0 gibuy
													,0 medi_amty_silson

											       ,0 insuren
												   ,0 disabled_insur_amtn
												   ,0 med_amtn
												   ,0 med_amtn_nanim
												   ,med_amt med_amtn_paria
												   ,0 edu_amtn
												   ,0 edu_amtn_paria
												   ,0 use_amt1n
												   ,0 debit_amtn
												   ,0 market_amtn
												   ,0 trans_amtn
												   ,0 book_amt_card_n 
												   ,0 book_amt_cash_n 
												   ,0 book_amt_check_n 
												   ,0 gibun
												   ,0 medi_amtn_silson
												   ,'KO512' CO_CD													
											FROM    hfa130t  
											WHERE   year_yy     ='2019' AND year_flag='y' AND  submit_flag<>'y' AND ISNULL(family_type,'') = 'A' and med_type not in ('B06')



											--UNION   ALL
											--SELECT  emp_no, family_nm,family_rel, dbo.ufn_getcodename('h0140',family_rel) family_rel_nm, 0 nat_flag, --2007.04.17
											--        0 insurey,0 disabled_insur_amty,0 emdiy, 0 edu_amty,0 use_amt1y,0 debit_amty, 0 use_amt2y,  0 market_amty, 0 trans_amty, 0 gibuy  ,
											--        0 insuren,0 disabled_insur_amtn,med_amt emdin, 0 edu_amtn,0 use_amt1n, 0 debit_amtn,  0 market_amtn, 0 trans_amtn, 0 gibun, CO_CD													
											--FROM    hfa130t  
											--WHERE   year_yy     ='2019' AND year_flag='y' AND  submit_flag<>'y' AND CO_CD = @co_cd
											UNION   ALL
											--교육비_국세청_일반 hfa090t-------------------------------
											SELECT  emp_no
												   ,family_name
												   ,family_rel
												   ,dbo.ufn_getcodename('h0140',family_rel) family_rel_nm
												   ,0 nat_flag
											       ,0 insurey
												   ,0 disabled_insur_amty
												   ,0 med_amty
												   ,0 med_amty_nanim
												   ,0 med_amty_paria
												   , sum(edu_amt) edu_amty
												   ,0 edu_amty_paria
												   ,0 use_amt1y
												   ,0 debit_amty
												   ,0 use_amt2y
												   ,0 market_amty
												   ,0 trans_amty
												   ,0 book_amt_card_y 
												   ,0 book_amt_cash_y 
												   ,0 book_amt_check_y 
												   ,0 gibuy
													,0 medi_amty_silson

											       ,0 insuren
												   ,0 disabled_insur_amtn
												   ,0 med_amtn
												   ,0 med_amtn_nanim
												   ,0 med_amtn_paria
												   ,0 edu_amtn
												   ,0 edu_amtn_paria
												   ,0 use_amt1n
												   ,0 debit_amtn
												   ,0 market_amtn
												   ,0 trans_amtn
												   ,0 book_amt_card_n 
												   ,0 book_amt_cash_n 
												   ,0 book_amt_check_n 
												   ,0 gibun
												   ,0 medi_amtn_silson
												   ,'KO512'CO_CD
											FROM    hfa090t  
											WHERE   yy= '2019' AND year_flag='y' AND  submit_flag='y'
											and family_type <>'H'
											group by emp_no, family_name, family_rel,dbo.ufn_getcodename('h0140',family_rel),  family_type	
											union all
											--교육비_국세청_장애인특수교육비 hfa090t-------------------------------
											SELECT  emp_no
												   ,family_name
												   ,family_rel
												   ,dbo.ufn_getcodename('h0140',family_rel) family_rel_nm
												   ,0 nat_flag
											       ,0 insurey
												   ,0 disabled_insur_amty
												   ,0 med_amty
												   ,0 med_amty_nanim
												   ,0 med_amty_paria
												   ,0 edu_amty
												   ,sum(edu_amt) edu_amty_paria
												   ,0 use_amt1y
												   ,0 debit_amty
												   ,0 use_amt2y
												   ,0 market_amty
												   ,0 trans_amty
												   ,0 book_amt_card_y 
												   ,0 book_amt_cash_y 
												   ,0 book_amt_check_y 
												   ,0 gibuy
													,0 medi_amty_silson

											       ,0 insuren
												   ,0 disabled_insur_amtn
												   ,0 med_amtn
												   ,0 med_amtn_nanim
												   ,0 med_amtn_paria
												   ,0 edu_amtn
												   ,0 edu_amtn_paria
												   ,0 use_amt1n
												   ,0 debit_amtn
												   ,0 market_amtn
												   ,0 trans_amtn
												   ,0 book_amt_card_n 
												   ,0 book_amt_cash_n 
												   ,0 book_amt_check_n 
												   ,0 gibun
												   ,0 medi_amtn_silson
												   ,'KO512'CO_CD
											FROM    hfa090t  
											WHERE   yy= '2019' AND year_flag='y' AND  submit_flag='y'
											and family_type ='H'
											group by emp_no, family_name, family_rel,dbo.ufn_getcodename('h0140',family_rel),  family_type	
											union all
											--교육비_기타_일반 hfa090t-------------------------------
											SELECT  emp_no
												   ,family_name
												   ,family_rel
												   ,dbo.ufn_getcodename('h0140',family_rel) family_rel_nm
												   ,0 nat_flag
											       ,0 insurey
												   ,0 disabled_insur_amty
												   ,0 med_amty
												   ,0 med_amty_nanim
												   ,0 med_amty_paria
												   ,0 edu_amty
												   ,0 edu_amty_paria
												   ,0 use_amt1y
												   ,0 debit_amty
												   ,0 use_amt2y
												   ,0 market_amty
												   ,0 trans_amty
												   ,0 book_amt_card_y 
												   ,0 book_amt_cash_y 
												   ,0 book_amt_check_y 
												   ,0 gibuy
													,0 medi_amty_silson

											       ,0 insuren
												   ,0 disabled_insur_amtn
												   ,0 med_amtn
												   ,0 med_amtn_nanim
												   ,0 med_amtn_paria
												   ,sum(edu_amt) edu_amtn
												   ,0 edu_amtn_paria
												   ,0 use_amt1n
												   ,0 debit_amtn
												   ,0 market_amtn
												   ,0 trans_amtn
												   ,0 book_amt_card_n 
												   ,0 book_amt_cash_n 
												   ,0 book_amt_check_n 
												   ,0 gibun
												   ,0 medi_amtn_silson
												   ,'KO512'CO_CD
											FROM    hfa090t  
											WHERE   yy= '2019' AND year_flag='y' AND  submit_flag<>'y'
											and family_type <>'H'
											group by emp_no, family_name, family_rel,dbo.ufn_getcodename('h0140',family_rel),  family_type	
											union all
											--교육비_기타_장애인특수교육비 hfa090t-------------------------------
											SELECT  emp_no
												   ,family_name
												   ,family_rel
												   ,dbo.ufn_getcodename('h0140',family_rel) family_rel_nm
												   ,0 nat_flag
											       ,0 insurey
												   ,0 disabled_insur_amty
												   ,0 med_amty
												   ,0 med_amty_nanim
												   ,0 med_amty_paria
												   ,0 edu_amty
												   ,0 edu_amty_paria
												   ,0 use_amt1y
												   ,0 debit_amty
												   ,0 use_amt2y
												   ,0 market_amty
												   ,0 trans_amty
												   ,0 book_amt_card_y 
												   ,0 book_amt_cash_y 
												   ,0 book_amt_check_y 
												   ,0 gibuy
													,0 medi_amty_silson

											       ,0 insuren
												   ,0 disabled_insur_amtn
												   ,0 med_amtn
												   ,0 med_amtn_nanim
												   ,0 med_amtn_paria
												   ,0 edu_amtn
												   ,sum(edu_amt) edu_amtn_paria
												   ,0 use_amt1n
												   ,0 debit_amtn
												   ,0 market_amtn
												   ,0 trans_amtn
												   ,0 book_amt_card_n 
												   ,0 book_amt_cash_n 
												   ,0 book_amt_check_n 
												   ,0 gibun
												   ,0 medi_amtn_silson
												   ,'KO512'CO_CD
											FROM    hfa090t  
											WHERE   yy= '2019' AND year_flag='y' AND  submit_flag<>'y'
											and family_type ='H'
											group by emp_no, family_name, family_rel,dbo.ufn_getcodename('h0140',family_rel),  family_type	
											--UNION   ALL
											--SELECT  emp_no, family_name,family_rel, dbo.ufn_getcodename('h0140',family_rel) family_rel_nm, 0 nat_flag, 
											--        0 insurey,0 disabled_insur_amty,0 emdiy, 0 edu_amty,0 use_amt1y,0 debit_amty, 0 use_amt2y,  0 market_amty, 0 trans_amty, 0 gibuy  ,
											--        0 insuren,0 disabled_insur_amtn,0 emdin, sum(edu_amt) edu_amtn,0 use_amt1n, 0 debit_amtn,  0 market_amtn, 0 trans_amtn, 0 gibun, CO_CD
											--FROM    hfa090t  
											--WHERE   yy= '2019' AND year_flag='y' AND  submit_flag<>'y' AND CO_CD = @co_cd 
											--group by emp_no, family_name, family_rel,dbo.ufn_getcodename('h0140',family_rel) ,  CO_CD,  family_type	
											UNION   ALL												
											--신용카드 hfa180t------------------------------- 
											SELECT emp_no, 
											       family_name, 
											       family_rel, 
											       dbo.Ufn_getcodename('h0140', family_rel) family_rel_nm, 
											       0 nat_flag, 
											       0 insurey, 
											       0 disabled_insur_amty, 
												   0 med_amty		,
												   0 med_amty_nanim	,
												   0 med_amty_paria	,
												   0 edu_amty		,
												   0 edu_amty_paria	,
											       use_amt use_amt1y, 
											       0 debit_amty, 
											       0 use_amt2y, 
											       0 market_amty, 
											       0 trans_amty, 
											       0 book_amt_card_y , 
											       0 book_amt_cash_y , 
											       0 book_amt_check_y, 
											       0 gibuy, 
													0 medi_amty_silson,

											       0 insuren, 
											       0 disabled_insur_amtn, 
												   0 med_amtn		,
												   0 med_amtn_nanim	,
												   0 med_amtn_paria	,
												   0 edu_amtn		,
												   0 edu_amtn_paria	,
											       0 use_amt1n, 
											       0 debit_amtn, 
											       0 market_amtn, 
											       0 trans_amtn, 
											       0 book_amt_card_n , 
											       0 book_amt_cash_n , 
											       0 book_amt_check_n, 
											       0 gibun, 
												   0 medi_amtn_silson,

											       'KO512'co_cd 
											FROM   hfa180t 
											WHERE  year_yy = '2019' AND year_flag = 'y' AND submit_flag = 'y' AND use_type = '1'
											UNION ALL 
											SELECT emp_no, 
											       family_name, 
											       family_rel, 
											       dbo.Ufn_getcodename('h0140', family_rel) family_rel_nm, 
											       0 nat_flag, 
											       0 insurey, 
											       0 disabled_insur_amty, 
												   0 med_amty		,
												   0 med_amty_nanim	,
												   0 med_amty_paria	,
												   0 edu_amty		,
												   0 edu_amty_paria	,
											       0 use_amt1y, 
											       0 debit_amty, 
											       0 use_amt2y, 
											       0 market_amty, 
											       0 trans_amty, 
											       0 book_amt_card_y , 
											       0 book_amt_cash_y , 
											       0 book_amt_check_y, 
											       0 gibuy, 
													0 medi_amty_silson,

											       0 insuren, 
											       0 disabled_insur_amtn, 
												   0 med_amtn		,
												   0 med_amtn_nanim	,
												   0 med_amtn_paria	,
												   0 edu_amtn		,
												   0 edu_amtn_paria	,
											       use_amt use_amt1n, 
											       0 debit_amtn, 
											       0 market_amtn, 
											       0 trans_amtn, 
											       0 book_amt_card_n , 
											       0 book_amt_cash_n, 
											       0 book_amt_check_n, 
												   0 medi_amtn_silson,
											       0 gibun, 
											       'KO512'co_cd 
											FROM   hfa180t 
											WHERE  year_yy = '2019' AND year_flag = 'y' AND submit_flag <> 'y' AND use_type = '1'
											UNION ALL 
											-- 2010 직불카드 hfa180t(debit_amty) 
											SELECT emp_no, 
											       family_name, 
											       family_rel, 
											       dbo.Ufn_getcodename('h0140', family_rel) family_rel_nm, 
											       0 nat_flag, 
											       0 insurey, 
											       0 disabled_insur_amty, 
												   0 med_amty		,
												   0 med_amty_nanim	,
												   0 med_amty_paria	,
												   0 edu_amty		,
												   0 edu_amty_paria	,
											       0 use_amt1y, 
											       use_amt debit_amty, 
											       0 use_amt2y, 
											       0 market_amty, 
											       0 trans_amty, 
											       0 book_amt_card_y , 
											       0 book_amt_cash_y , 
											       0 book_amt_check_y, 
											       0 gibuy, 
													0 medi_amty_silson,

											       0 insuren, 
											       0 disabled_insur_amtn, 
												   0 med_amtn		,
												   0 med_amtn_nanim	,
												   0 med_amtn_paria	,
												   0 edu_amtn		,
												   0 edu_amtn_paria	,
											       0 use_amt1n, 
											       0 debi_amtn, 
											       0 market_amtn, 
											       0 trans_amtn, 
											       0 book_amt_card_n , 
											       0 book_amt_cash_n , 
											       0 book_amt_check_n, 
											       0 gibun, 
												   0 medi_amtn_silson,
											       'KO512'co_cd 
											FROM   hfa180t 
											WHERE  year_yy = '2019'        AND year_flag = 'y'        AND submit_flag = 'y'        AND use_type = '6'
											UNION ALL 
											--직불카드등외(debit_amtn) 
											SELECT emp_no, 
											       family_name, 
											       family_rel, 
											       dbo.Ufn_getcodename('h0140', family_rel) family_rel_nm, 
											       0 nat_flag, 
											       0 insurey, 
											       0 disabled_insur_amty, 
												   0 med_amty		,
												   0 med_amty_nanim	,
												   0 med_amty_paria	,
												   0 edu_amty		,
												   0 edu_amty_paria	,
											       0 use_amt1y, 
											       0 debit_amty, 
											       0 use_amt2y, 
											       0 market_amty, 
											       0 trans_amty, 
											       0 book_amt_card_y , 
											       0 book_amt_cash_y , 
											       0 book_amt_check_y, 
											       0 gibuy,
													0 medi_amty_silson,
												    
											       0 insuren, 
											       0 disabled_insur_amtn, 
												   0 med_amtn		,
												   0 med_amtn_nanim	,
												   0 med_amtn_paria	,
												   0 edu_amtn		,
												   0 edu_amtn_paria	,
											       0 use_amt1n, 
											       use_amt debit_amtn, 
											       0 market_amtn, 
											       0 trans_amtn, 
											       0 book_amt_card_n , 
											       0 book_amt_cash_n , 
											       0 book_amt_check_n, 
											       0 gibun, 
												   0 medi_amtn_silson,
											       'KO512'co_cd 
											FROM   hfa180t 
											WHERE  year_yy = '2019'        AND year_flag = 'y'        AND submit_flag <> 'y'        AND use_type = '6'
											UNION ALL 
											--현금영수증 hfa180t------------------------------- 
											SELECT emp_no, 
											       family_name, 
											       family_rel, 
											       dbo.Ufn_getcodename('h0140', family_rel) family_rel_nm, 
											       0 nat_flag, 
											       0 insurey, 
											       0 disabled_insur_amty, 
												   0 med_amty		,
												   0 med_amty_nanim	,
												   0 med_amty_paria	,
												   0 edu_amty		,
												   0 edu_amty_paria	,
											       0 use_amt1y, 
											       0 debit_amty, 
											       use_amt use_amt2y, 
											       0 market_amty, 
											       0 trans_amty, 
											       0 book_amt_card_y , 
											       0 book_amt_cash_y , 
											       0 book_amt_check_y, 
											       0 gibuy, 
													0 medi_amty_silson,

											       0 insuren, 
											       0 disabled_insur_amtn, 
												   0 med_amtn		,
												   0 med_amtn_nanim	,
												   0 med_amtn_paria	,
												   0 edu_amtn		,
												   0 edu_amtn_paria	,
											       0 use_amt1n, 
											       0 debit_amtn, 
											       0 market_amtn, 
											       0 trans_amtn, 
											       0 book_amt_card_n , 
											       0 book_amt_cash_n , 
											       0 book_amt_check_n, 
											       0 gibun, 
												   0 medi_amtn_silson,
											       'KO512'co_cd 
											FROM   hfa180t 
											WHERE  year_yy = '2019'        AND use_type = '2'        AND year_flag = 'y'        AND submit_flag = 'y'
											UNION ALL 
											--2012 전통시장 hfa180t------------------------------- 
											SELECT emp_no, 
											       family_name, 
											       family_rel, 
											       dbo.Ufn_getcodename('h0140', family_rel) family_rel_nm, 
											       0 nat_flag, 
											       0 insurey, 
											       0 disabled_insur_amty, 
												   0 med_amty		,
												   0 med_amty_nanim	,
												   0 med_amty_paria	,
												   0 edu_amty		,
												   0 edu_amty_paria	,
											       0 use_amt1y, 
											       0 debit_amty, 
											       0 use_amt2y, 
											       use_amt market_amty, 
											       0 trans_amty, 
											       0 book_amt_card_y , 
											       0 book_amt_cash_y , 
											       0 book_amt_check_y, 
											       0 gibuy, 
														0 medi_amty_silson,

											       0 insuren, 
											       0 disabled_insur_amtn, 
												   0 med_amtn		,
												   0 med_amtn_nanim	,
												   0 med_amtn_paria	,
												   0 edu_amtn		,
												   0 edu_amtn_paria	,
											       0 use_amt1n, 
											       0 debit_amtn, 
											       0 market_amtn, 
											       0 trans_amtn, 
											       0 book_amt_card_n , 
											       0 book_amt_cash_n , 
											       0 book_amt_check_n, 
											       0 gibun, 
												   0 medi_amtn_silson,
											       'KO512'co_cd 
											FROM   hfa180t 
											WHERE  year_yy = '2019'        AND use_type IN ( '7', '8', '9' )        AND year_flag = 'y'       AND submit_flag = 'y'
											UNION ALL 
											SELECT emp_no, 
											       family_name, 
											       family_rel, 
											       dbo.Ufn_getcodename('h0140', family_rel) family_rel_nm, 
											       0 nat_flag, 
											       0 insurey, 
											       0 disabled_insur_amty, 
												   0 med_amty		,
												   0 med_amty_nanim	,
												   0 med_amty_paria	,
												   0 edu_amty		,
												   0 edu_amty_paria	,
											       0 use_amt1y, 
											       0 debit_amty, 
											       0 use_amt2y, 
											       0 market_amty, 
											       0 trans_amty, 
											       0 book_amt_card_y , 
											       0 book_amt_cash_y , 
											       0 book_amt_check_y, 
											       0 gibuy, 
												0 medi_amty_silson,

											       0 insuren, 
											       0 disabled_insur_amtn, 
												   0 med_amtn		,
												   0 med_amtn_nanim	,
												   0 med_amtn_paria	,
												   0 edu_amtn		,
												   0 edu_amtn_paria	,
											       0 use_amt1n, 
											       0 debit_amtn, 
											       use_amt market_amtn, 
											       0 trans_amtn, 
											       0 book_amt_card_n , 
											       0 book_amt_cash_n , 
											       0 book_amt_check_n, 
											       0 gibun, 
												   0 medi_amtn_silson,
											       'KO512'co_cd 
											FROM   hfa180t 
											WHERE  year_yy = '2019'        AND use_type IN ( '7', '8', '9' )        AND year_flag = 'y'        AND submit_flag <> 'y'
											UNION ALL 
											--2013 대중교통이용분 
											--20140205-221380 신용카드오류 use_type = 'A' ->use_type in ('A','B','C')   
											SELECT emp_no, 
											       family_name, 
											       family_rel, 
											       dbo.Ufn_getcodename('h0140', family_rel) family_rel_nm, 
											       0 nat_flag, 
											       0 insurey, 
											       0 disabled_insur_amty, 
												   0 med_amty		,
												   0 med_amty_nanim	,
												   0 med_amty_paria	,
												   0 edu_amty		,
												   0 edu_amty_paria	,
											       0 use_amt1y, 
											       0 debit_amty, 
											       0 use_amt2y, 
											       0 market_amty, 
											       use_amt trans_amty, 
											       0 book_amt_card_y , 
											       0 book_amt_cash_y , 
											       0 book_amt_check_y, 
											       0 gibuy, 
												0 medi_amty_silson,

											       0 insuren, 
											       0 disabled_insur_amtn, 
												   0 med_amtn		,
												   0 med_amtn_nanim	,
												   0 med_amtn_paria	,
												   0 edu_amtn		,
												   0 edu_amtn_paria	,
											       0 use_amt2n, 
											       0 debit_amtn, 
											       0 market_amtn, 
											       0 trans_amtn, 
											       0 book_amt_card_n , 
											       0 book_amt_cash_n , 
											       0 book_amt_check_n, 
											       0 gibun, 
												   0 medi_amtn_silson,

											       'KO512'co_cd 
											FROM   hfa180t 
											WHERE  year_yy = '2019'        AND year_flag = 'y'        AND submit_flag = 'y'        AND use_type IN ( 'A', 'B', 'C' )
											UNION ALL 
											SELECT emp_no, 
											       family_name, 
											       family_rel, 
											       dbo.Ufn_getcodename('h0140', family_rel) family_rel_nm, 
											       0 nat_flag, 
											       0 insurey, 
											       0 disabled_insur_amty, 
												   0 med_amty		,
												   0 med_amty_nanim	,
												   0 med_amty_paria	,
												   0 edu_amty		,
												   0 edu_amty_paria	,
											       0 use_amt1y, 
											       0 debit_amty, 
											       0 use_amt2y, 
											       0 market_amty, 
											       0 trans_amty, 
											       0 book_amt_card_y   , 
											       0 book_amt_cash_y  , 
											       0 book_amt_check_y, 
											       0 gibuy, 
													0 medi_amty_silson,

											       0 insuren, 
											       0 disabled_insur_amtn, 
												   0 med_amtn		,
												   0 med_amtn_nanim	,
												   0 med_amtn_paria	,
												   0 edu_amtn		,
												   0 edu_amtn_paria	,
											       0 use_amt1n, 
											       0 debit_amtn, 
											       0 market_amtn, 
											       use_amt trans_amtn, 
											       0 book_amt_card_n , 
											       0 book_amt_cash_n , 
											       0 book_amt_check_n, 
											       0 gibun, 
												   0 medi_amtn_silson,

											       'KO512'co_cd 
											FROM   hfa180t 
											WHERE  year_yy = '2019'        AND year_flag = 'y'        AND submit_flag <> 'y'        AND use_type IN ( 'A', 'B', 'C' ) 
											
											 UNION ALL 
											--2018 도서공연비이용분 
											SELECT emp_no, 
											       family_name, 
											       family_rel, 
											       dbo.Ufn_getcodename('h0140', family_rel) family_rel_nm, 
											       0 nat_flag, 
											       0 insurey, 
											       0 disabled_insur_amty, 
												   0 med_amty		,
												   0 med_amty_nanim	,
												   0 med_amty_paria	,
												   0 edu_amty		,
												   0 edu_amty_paria	,
											       0 use_amt1y, 
											       0 debit_amty, 
											       0 use_amt2y, 
											       0 market_amty, 
											       0 trans_amty, 
												   case when use_type = 'D' then use_amt else 0 end book_amt_card_y   , 
												   case when use_type = 'E' then use_amt else 0 end book_amt_cash_y  , 
												   case when use_type = 'F' then use_amt else 0 end book_amt_check_y, 
											       0 gibuy, 
												0 medi_amty_silson,

											       0 insuren, 
											       0 disabled_insur_amtn, 
												   0 med_amtn		,
												   0 med_amtn_nanim	,
												   0 med_amtn_paria	,
												   0 edu_amtn		,
												   0 edu_amtn_paria	,
											       0 use_amt2n, 
											       0 debit_amtn, 
											       0 market_amtn, 
											       0 trans_amtn, 
											       0 book_amt_card_n , 
											       0 book_amt_cash_n , 
											       0 book_amt_check_n, 
											       0 gibun, 
												   0 medi_amtn_silson,

											       'KO512'co_cd 
											FROM   hfa180t 
											WHERE  year_yy = '2019'        AND year_flag = 'y'        AND submit_flag = 'y'        AND use_type IN ( 'D', 'E', 'F' )
											UNION ALL 
											SELECT emp_no, 
											       family_name, 
											       family_rel, 
											       dbo.Ufn_getcodename('h0140', family_rel) family_rel_nm, 
											       0 nat_flag, 
											       0 insurey, 
											       0 disabled_insur_amty, 
												   0 med_amty		,
												   0 med_amty_nanim	,
												   0 med_amty_paria	,
												   0 edu_amty		,
												   0 edu_amty_paria	,
											       0 use_amt1y, 
											       0 debit_amty, 
											       0 use_amt2y, 
											       0 market_amty, 
											       0 trans_amty, 
											       0 book_amt_card_y   , 
											       0 book_amt_cash_y  , 
											       0 book_amt_check_y, 
											       0 gibuy, 
											0 medi_amty_silson,

											       0 insuren, 
											       0 disabled_insur_amtn, 
												   0 med_amtn		,
												   0 med_amtn_nanim	,
												   0 med_amtn_paria	,
												   0 edu_amtn		,
												   0 edu_amtn_paria	,
											       0 use_amt1n, 
											       0 debit_amtn, 
											       0 market_amtn, 
											       0 trans_amtn, 
												   case when use_type = 'D' then use_amt else 0 end book_amt_card_n   , 
												   case when use_type = 'E' then use_amt else 0 end book_amt_cash_n  , 
												   case when use_type = 'F' then use_amt else 0 end book_amt_check_n, 
												   0 medi_amtn_silson,

											       0 gibun, 
											       'KO512'co_cd 
											FROM   hfa180t 
											WHERE  year_yy = '2019'        AND year_flag = 'y'        AND submit_flag <> 'y'        AND use_type IN ( 'D', 'E', 'F' )
											UNION   ALL
											--2012 기부금 hfa140t 해당년도 기부금만 ---------------------------
											SELECT  emp_no
											       ,family_nm
												   ,family_rel
												   ,dbo.ufn_getcodename('h0140',family_rel) family_rel_nm
											       ,0 nat_flag 
											       ,0 insurey 
											       ,0 disabled_insur_amty 
												   ,0 med_amty		
												   ,0 med_amty_nanim	
												   ,0 med_amty_paria	
												   ,0 edu_amty		
												   ,0 edu_amty_paria	
											       ,0 use_amt1y 
											       ,0 debit_amty 
											       ,0 use_amt2y 
											       ,0 market_amty 
											       ,0 trans_amty 
												   ,0 book_amt_card_y    
												   ,0 book_amt_cash_y   
												   ,0 book_amt_check_y 
												   ,contr_amt gibuy  
													,0 medi_amty_silson

											       ,0 insuren 
											       ,0 disabled_insur_amtn 
												   ,0 med_amtn		
												   ,0 med_amtn_nanim	
												   ,0 med_amtn_paria	
												   ,0 edu_amtn		
												   ,0 edu_amtn_paria	
											       ,0 use_amt1n 
											       ,0 debit_amtn 
											       ,0 market_amtn 
											       ,0 trans_amtn 
												   ,0 book_amt_card_n    
												   ,0 book_amt_cash_n   
												   ,0 book_amt_check_n  
												   ,0 gibun
												   ,0 medi_amtn_silson

												   ,'KO512'CO_CD													
											FROM    hfa140t  
											WHERE year_yy='2019' AND year_flag='y' AND  submit_flag='y'
											UNION   ALL
											SELECT  emp_no
											       ,family_nm
												   ,family_rel
												   ,dbo.ufn_getcodename('h0140',family_rel) family_rel_nm
											       ,0 nat_flag 
											       ,0 insurey 
											       ,0 disabled_insur_amty 
												   ,0 med_amty		
												   ,0 med_amty_nanim	
												   ,0 med_amty_paria	
												   ,0 edu_amty		
												   ,0 edu_amty_paria	
											       ,0 use_amt1y 
											       ,0 debit_amty 
											       ,0 use_amt2y 
											       ,0 market_amty 
											       ,0 trans_amty 
												   ,0 book_amt_card_y    
												   ,0 book_amt_cash_y   
												   ,0 book_amt_check_y 
												   ,0 gibuy  
													,0 medi_amty_silson

											       ,0 insuren 
											       ,0 disabled_insur_amtn 
												   ,0 med_amtn		
												   ,0 med_amtn_nanim	
												   ,0 med_amtn_paria	
												   ,0 edu_amtn		
												   ,0 edu_amtn_paria	
											       ,0 use_amt1n 
											       ,0 debit_amtn 
											       ,0 market_amtn 
											       ,0 trans_amtn 
												   ,0 book_amt_card_n    
												   ,0 book_amt_cash_n   
												   ,0 book_amt_check_n
												   ,contr_amt gibun--gibun
												   ,0 medi_amtn_silson
												   ,'KO512'CO_CD												
											FROM  hfa140t  
											WHERE year_yy='2019' AND year_flag='y' AND  submit_flag<>'y'
          ) b ON a.emp_no = b.emp_no AND REPLACE(a.family_name,' ','') = REPLACE(b.family_name,' ','') AND a.year_yy = '2019' --AND a.CO_CD = b.CO_CD   
          and a.FAMILY_REL = b.family_rel  
     INNER JOIN haa010t c ON a.emp_no = c.emp_no
   WHERE 1   = 1  
   AND A.EMP_NO = '20100003'
   AND  a.year_yy = '2019'  
   AND  a.emp_no IN (  
          SELECT haa010t.emp_no  
          FROM haa010t  
           , hfa050t  
           , hdf020t  
           , hfa100t  
           , hfa030t  
          WHERE haa010t.emp_no   = hdf020t.emp_no  
          AND  hdf020t.emp_no   = hfa050t.emp_no  
          AND  hfa050t.year_yy   = hfa030t.yy  
          AND  hfa050t.emp_no   = hfa030t.emp_no  
          AND  (CASE WHEN ISNULL(hfa050t.year_area_cd,'') = '' THEN haa010t.year_area_cd ELSE hfa050t.year_area_cd END) = hfa100t.year_area_cd -- 20101028-174209  
          AND  hdf020t.year_mon_give = 'y'  
          AND  isnull(haa010t.group_entr_dt,haa010t.entr_dt) < '2019' + '-12-31'  
          AND  hfa050t.year_yy   = '2019'  
          --AND  HFA050T.CO_CD   = @co_cd  
          -- 퇴사자포함여부 1 전체, 2 재직자만, 3 퇴직자만  
          --AND  CASE WHEN '1' = '1' THEN CASE WHEN (haa010t.retire_dt is null or haa010t.retire_dt >= '20191231' OR CONVERT(NVARCHAR(04), DATEPART(YEAR, haa010t.retire_dt)) = '2019') THEN '1' END  
          --    WHEN '1' = '2' THEN CASE WHEN (haa010t.retire_dt is null or haa010t.retire_dt > '20191231' OR (CONVERT(NVARCHAR(04), DATEPART(YEAR, haa010t.retire_dt)) = '2019' AND haa010t.retire_resn  = '6')) THEN '2' END  
          --    WHEN '1' = '3' THEN CASE WHEN (CONVERT(NVARCHAR(04), DATEPART(YEAR, haa010t.retire_dt)) = '2019' and haa010t.retire_resn  <> '6') THEN '3' END  
          --  END  = '1'  
           -- 20150227 재직자구분 조건 수정 ( 기준일자까지 재직자로 )  --0304 매년 말일에만 다른조건 사용하게 변경(김상현)  
          AND CASE WHEN haa010t.EMP_NO <> '20090131' THEN CASE WHEN '20191231' = ('2019' + '1231') THEN   
            (CASE WHEN '1' = '1' THEN CASE WHEN (haa010t.retire_dt IS NULL OR haa010t.retire_dt >= '20191231' OR CONVERT(NVARCHAR(04), DATEPART(YEAR, haa010t.retire_dt)) = '2019') THEN '1' END  
            WHEN '1' = '2' THEN CASE WHEN (haa010t.retire_dt is null or haa010t.retire_dt >= '20191231' OR (CONVERT(NVARCHAR(04), DATEPART(YEAR, haa010t.retire_dt)) = '2019' AND haa010t.retire_resn = '6')) THEN '2' END  
            WHEN '1' = '3' THEN CASE WHEN (haa010t.retire_dt < '20191231' and CONVERT(NVARCHAR(04), DATEPART(YEAR, haa010t.retire_dt)) = '2019' AND haa010t.retire_resn  <> '6') THEN '3' END  
            END)  
           ELSE  
            (CASE WHEN '1' = '1' THEN CASE WHEN (haa010t.retire_dt IS NULL OR haa010t.retire_dt >= '20191231' OR CONVERT(NVARCHAR(04), DATEPART(YEAR, haa010t.retire_dt)) = '2019') THEN '1' END  
            WHEN '1' = '2' THEN CASE WHEN (haa010t.retire_dt is null or haa010t.retire_dt > '20191231' OR (CONVERT(NVARCHAR(04), DATEPART(YEAR, haa010t.retire_dt)) = '2019' AND haa010t.retire_resn = '6')) THEN '2' END  
            WHEN '1' = '3' THEN CASE WHEN (haa010t.retire_dt <= '20191231' and CONVERT(NVARCHAR(04), DATEPART(YEAR, haa010t.retire_dt)) = '2019' AND haa010t.retire_resn  <> '6') THEN '3' END  
            END)  END ELSE '1' END  = '1'  
         )  

   GROUP BY RTRIM(REPLACE(a.family_res_no,'-','')), a.emp_no, a.family_name, a.family_rel, c.YEAR_AREA_CD  
     , dbo.ufn_getcodename('h0140',a.family_rel), a.nat_flag,A.PARIA_YN



