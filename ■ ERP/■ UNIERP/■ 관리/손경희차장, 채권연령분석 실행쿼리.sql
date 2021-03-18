BEGIN TRAN


     delete a from A_BILL_FIFO_CALC_DTL a,A_BILL_FIFO_CALC b  where a.ref_gl_no=b.gl_no and a.ref_item_seq=b.item_seq          
         and ACCT_CD>='1110501' and ACCT_CD<='1110507'                     
      DELETE A_BILL_FIFO_CALC WHERE ACCT_CD>='1110501' and ACCT_CD<='1110507'                          
                 
     -- DELETE A FROM  A_BILL_FIFO_CALC_DTL  A, A_MACHUL_GICHO2 B WHERE A.REF_GL_NO='0-'+YYYYMMDD+'-'+DEPT_CD+'-'+BP_CD+'-'+ACCT_CD                        
      DELETE A_BILL_FIFO_OVER WHERE ACCT_CD>='1110501' and ACCT_CD<='1110507'
      
	   
	 DELETE A_BILL_TOTAL_CACL 
	 INSERT INTO A_BILL_TOTAL_CACL 
	 SELECT SUBSTRING(CONVERT(VARCHAR(8), GETDATE(), 112),1,6),SUBSTRING(CONVERT(VARCHAR(8), GETDATE(), 112),1,6),SUBSTRING(CONVERT(VARCHAR(8), GETDATE(), 112),1,6),'admin',GETDATE()    
                

 --매출채권
 
 DECLARE @BILL_dT_FR DATETIME
  ,@BILL_dT_TO DATETIME
 
   DECLARE BILL_CUR SCROLL CURSOR FOR        
 select '2014-01-01','2014-01-31'
 union all
 select '2014-02-01','2014-02-28'
 union all
 select '2014-03-01','2014-03-31'
 union all
  select '2014-04-01','2014-04-30'
 union all
  select '2014-05-01','2014-05-31'
 union all
  select '2014-06-01','2014-06-30'
 union all
  select '2014-07-01','2014-07-31'
  union all
  select '2014-08-01','2014-08-31'
  union all
  select '2014-09-01','2014-09-30'
  union all
  select '2014-10-01','2014-10-31'
  union all
  select '2014-11-01','2014-11-30'
  union all
  select '2014-12-01','2014-12-31'
  union all
  select '2015-01-01','2015-01-31'
  union all
  select '2015-02-01','2015-02-28'
  union all
  select '2015-03-01','2015-03-31'
  union all 
  select '2015-04-01','2015-04-30'
  union all 
  select '2015-05-01','2015-05-31'
  union all 
  select '2015-06-01','2015-06-30'  
  union all 
  select '2015-07-01','2015-07-31' 
  union all 
  select '2015-08-01','2015-08-31' 
  union all 
  select '2015-09-01','2015-09-30' 
  union all 
  select '2015-10-01','2015-10-31' 
  union all 
  select '2015-11-01','2015-11-30' 
  union all 
  select '2015-12-01','2015-12-31' 
  union all 
  select '2016-01-01','2016-01-31' 
  union all 
  select '2016-02-01','2016-02-29' 
  union all 
  select '2016-03-01','2016-03-31' 
  union all 
  select '2016-04-01','2016-04-30' 
  union all 
  select '2016-05-01','2016-05-31' 
  union all 
  select '2016-06-01','2016-06-30' 
  union all 
  select '2016-07-01','2016-07-31' 
  union all 
  select '2016-08-01','2016-08-31' 
  union all 
  select '2016-09-01','2016-09-30' 
  union all 
  select '2016-10-01','2016-10-31' 
  union all 
  select '2016-11-01','2016-11-30' 
  union all 
  select '2016-12-01','2016-12-31' 
  union all 
  select '2017-01-01','2017-01-31' 
  union all 
  select '2017-02-01','2017-02-28' 
  union all 
  select '2017-03-01','2017-03-31' 
  union all 
  select '2017-04-01','2017-04-30' 
  union all 
  select '2017-05-01','2017-05-31' 
  union all 
  select '2017-06-01','2017-06-30' 
  union all 
  select '2017-07-01','2017-07-31' 
  union all 
  select '2017-08-01','2017-08-31' 
  union all 
  select '2017-09-01','2017-09-30'
  union all 
  select '2017-10-01','2017-10-31' 
  union all 
  select '2017-11-01','2017-11-30' 
  union all 
  select '2017-12-01','2017-12-31' 
  union all 
  select '2018-01-01','2018-01-31' 
  union all 
  select '2018-02-01','2018-02-28'
  union all 
  select '2018-03-01','2018-03-31'
  union all 
  select '2018-04-01','2018-04-30'
  union all 
  select '2018-05-01','2018-05-31'
  union all
  select '2018-06-01','2018-06-30'
  union all
  select '2018-07-01','2018-07-31'
    union all
  select '2018-08-01','2018-08-31'
  union all
  select '2018-09-01','2018-09-30'
  UNION ALL
  SELECT '2018-10-01','2018-10-31'
  UNION ALL
  SELECT '2018-11-01','2018-11-30'
  UNION ALL
  SELECT '2018-12-01','2018-12-31'
  UNION ALL
  SELECT '2019-01-01','2019-01-31'
  UNION ALL
  SELECT '2019-02-01','2019-02-28'
  UNION ALL
  SELECT '2019-03-01','2019-03-31'
  UNION ALL
  SELECT '2019-04-01','2019-04-30'
  UNION ALL
  SELECT '2019-05-01','2019-05-31'
    UNION ALL
  SELECT '2019-06-01','2019-06-30'
      UNION ALL
  SELECT '2019-07-01','2019-07-31'
   UNION ALL
  SELECT '2019-08-01','2019-08-31'
   UNION ALL
  SELECT '2019-09-01','2019-09-30'
    UNION ALL
  SELECT '2019-10-01','2019-10-31'
     UNION ALL
  SELECT '2019-11-01','2019-11-30'
   UNION ALL
  SELECT '2019-12-01','2019-12-31'
    UNION ALL
  SELECT '2020-01-01','2020-01-31'
    UNION ALL
  SELECT '2020-02-01','2020-02-29'
    UNION ALL
  SELECT '2020-03-01','2020-03-31'
    UNION ALL
  SELECT '2020-04-01','2020-04-30'
    UNION ALL
  SELECT '2020-05-01','2020-05-31'
      UNION ALL
  SELECT '2020-06-01','2020-06-30'
   UNION ALL
  SELECT '2020-07-01','2020-07-31'
    UNION ALL
  SELECT '2020-08-01','2020-08-31'
    UNION ALL
  SELECT '2020-09-01','2020-09-30'
  UNION ALL
  SELECT '2020-10-01','2020-10-31'

   OPEN BILL_CUR               
  
   FETCH NEXT FROM BILL_CUR INTO @BILL_dT_FR,@BILL_dT_TO 
   
   
     WHILE(@@FETCH_STATUS = 0)                      
   BEGIN      
  exec USP_A_BILL_MACHUL_2013 @BILL_dT_FR,@BILL_dT_TO--
  FETCH NEXT FROM BILL_CUR INTO @BILL_dT_FR,@BILL_dT_TO
 END
 
 CLOSE      BILL_CUR                    
  DEALLOCATE BILL_CUR             
                        

            COMMIT
