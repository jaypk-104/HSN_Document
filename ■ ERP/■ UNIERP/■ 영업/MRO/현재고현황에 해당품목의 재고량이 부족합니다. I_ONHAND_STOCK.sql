 --구매입고등록 
 --현재고현황에 해당품목의 재고량이 부족합니다. 재고현황을 확인하세요 
 
 select      curr_yr,      curr_mnth,       good_on_hand_qty, bad_on_hand_qty,      prev_good_qty,   
 prev_bad_qty, stk_on_insp_qty, stk_on_trns_qty,  prev_stk_on_insp_qty, prev_stk_in_trns_qty 
 from i_onhand_stock_detail (nolock)  where item_cd     = N'a1214n05325' and 
   plant_cd    = N'01' and   sl_cd       = N't11' and   tracking_no = N'*' and   lot_no      = N'*' and   lot_sub_no  = 0


   select *
   from I_ONHAND_STOCK_DETAIL
   order by updt_dt desc

   select *
   from I_ONHAND_STOCK_DETAIL
   where item_cd = 'a1214n05325'

      select *
   from I_ONHAND_STOCK
   where item_cd = 'a1214n05325'

   begin tran
   update I_ONHAND_STOCK_DETAIL
   set GOOD_ON_HAND_QTY = 1000,
   updt_dt = getdate(),
   UPDT_USER_ID = 'admingr'
   where item_cd = 'a1214n05325'

      begin tran
   update I_ONHAND_STOCK
   set GOOD_ON_HAND_QTY = 1000,
   updt_dt = getdate(),
   UPDT_USER_ID = 'admingr'
   where item_cd = 'a1214n05325'



         select *
   from I_ONHAND_STOCK
   where item_cd = 'a1214n05325'

   select *
   from m_pur_goods_mvmt
   where mvmt_rcpt_No = 'GR20191129000068'
