package com.samyang.winplus.sis.order.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.samyang.winplus.sis.order.dao.OrderRequestDao;
import com.samyang.winplus.sis.order.service.OrderRequestService;

@Service("OrderRequestService")
public class OrderRequestServiceImpl implements OrderRequestService {
	
	@Autowired
	OrderRequestDao orderRequestDao;
	
	private final Logger logger = LoggerFactory.getLogger(getClass());

	@Override
	public int insertReqGoodsTmp(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int updateReqGoodsTmp(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}
	
	@Override
	public int updateTpdaTempStatus(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}
	
	@Override
	public int deleteReqGoodsTmp(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}
	
	@Override
	public List<Map<String, Object>> getSearchReqGoodsTmp(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderRequestDao.getSearchReqGoodsTmp(paramMap);
	}

	@Override
	public List<Map<String, Object>> getSearchReqGoodsCSportal(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderRequestDao.getSearchReqGoodsCSportal(paramMap);
	}

	@Override
	public List<Map<String, Object>> getSearchReqFreshGoodsTmp(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderRequestDao.getSearchReqFreshGoodsTmp(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getSearchReqGoodsTmpOnly(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderRequestDao.getSearchReqGoodsTmpOnly(paramMap);
	}
	
	@Override
	public Map<String, Object> getReservDateWinplus(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderRequestDao.getReservDateWinplus(paramMap);
	}
	

	@Override
	public Map<String, Object> getReservDateSuply(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderRequestDao.getReservDateSuply(paramMap);
	}
	
	@Override
	public Map<String, Object> getCreditLoanBAL(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderRequestDao.getCreditLoanBAL(paramMap);
	}	
	
	@Override
	public int insertTstdMastCreditLoan(Map<String, Object> paramMap) throws SQLException, Exception {
		return orderRequestDao.insertTstdMastCreditLoan(paramMap);
	}	

	/**
	  * saveOrdReqGoodsTmp -  주문요청서 C,U,D
	  * @author 손경락
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  * 
	  * 1. 수량이 null이면 insert 대상에서 제외한다. 
	  * 
	  */
	@Transactional
	@Override
	public int  saveOrdReqGoodsTmp(List<Map<String, Object>> paramMapList, Map<String, Object> paramMap) throws SQLException, Exception {
		int resultInt  = 0;
		int proces_cnt = 0;
        String ls_req_qty = "";
        String ls_ord_typ = "";
        String ls_ORI_ORD_NO = "";
        String ls_ORG_CUSTMR = "";
        String ls_FLAG = "";
        
        
        logger.debug("@@@@@@@@@@ saveTpurOrdGoodsScreenList.java 주문요청서 처리 ============" );

        for(Map<String, Object> processMap : paramMapList){
			Object crud    = processMap.get("CRUD");
			Object ORD_SEQ = processMap.get("ORD_SEQ");
			ls_ord_typ     = processMap.get("ORD_CUSTMR_TYPE").toString();
			ls_ORI_ORD_NO  = processMap.get("ORI_ORD_NO").toString();
			ls_ORG_CUSTMR  = processMap.get("CHG_WARE_CD").toString();
			
			/* 고객사 발주요청 */
			processMap.put("PROCESS_MODE", "REQ");
			
			/* 수량이 없으면 SKIP한다 */
			ls_req_qty      = processMap.get("REQ_QTY").toString();
			
			/* 2020-01-07 ※아주중요 발주예정건만 처리한다 */
			ls_FLAG         = processMap.get("FLAG").toString(); 
			if ( !"1".equals(ls_FLAG) )        continue;
			
			if (ls_req_qty == null || ls_req_qty.length() == 0) {
                continue;
			} 			
			
			if ( Double.parseDouble(ls_req_qty) == 0.0 ) {
                continue;
			}
			
			if (ORD_SEQ == null ||  ORD_SEQ.toString().length() == 0   ) {
				crud = "C";
				logger.debug(" ORD_SEQ  == null crud  ==> " + crud);
			} 
			logger.debug(" crud  ==> " + crud);

			if(crud != null) {
				if("C".equals(crud)){
					processMap.put("ORI_ORD_NO",     ls_ORI_ORD_NO);   /* 원발주번호*/
					processMap.put("ORI_CUSTMER_CD", ls_ORG_CUSTMR);   /* 배송지(착지변경,일배,신선) 취급점이면 거래처코드, 직영점이면 조직코드 */ 
					processMap.put("PARAM_PROGRM", "insertOrderGoods");
					resultInt  += orderRequestDao.insertReqGoodsTmp(processMap);
					proces_cnt += 1;
                    /* PDA발주 */
					if("2".equals(ls_ord_typ)){
						processMap.put("PARAM_FLAG"   , "Y");        
						resultInt  += orderRequestDao.updateTpdaTempStatus(processMap);
					}
					
				} else if ("U".equals(crud)){
					processMap.put("PARAM_PROGRM", "updateOrderGoods");
					resultInt  += orderRequestDao.updateReqGoodsTmp(processMap);
					proces_cnt += 1;
				} else if ("D".equals(crud)){
					resultInt += orderRequestDao.deleteReqGoodsTmp(processMap);
                    /* PDA발주 */
					if("2".equals(ls_ord_typ)){
						processMap.put("PARAM_FLAG", "0");        
						resultInt  += orderRequestDao.updateTpdaTempStatus(processMap);
					}
					proces_cnt += 1;
				}
			}
		}
		
		return 0;
		
	}

	/**
	  * UpdateOrdReqGoodsTmp - 주문요청서 Update (협력사 포털에서 출고수량등록 하는데, 발주내역을 불러다 등록) 
	  * @author 손경락
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  * 
	  * 1. 수량이 null이면 Update 대상에서 제외한다. 
	  * 
	  */
	@Transactional
	@Override
	public int  UpdateOrdReqGoodsTmp(List<Map<String, Object>> paramMapList, Map<String, Object> paramMap) throws SQLException, Exception {
	   int proces_cnt = 0;
       String ls_req_qty    = "";
       String[] ls_out_arr  =  paramMap.get("OUT_DATE").toString().split("-");
       String ls_out_date   =  ls_out_arr[0]+ls_out_arr[1]+ls_out_arr[2];
       
       logger.debug("@@@@@@@@@@ UpdateOrdReqGoodsTmp.java 출고수량등록 처리 OUT_DATE[" +  ls_out_date + "]============" );

       for(Map<String, Object> processMap : paramMapList){
			Object crud    = processMap.get("CRUD");
			Object ORD_SEQ = processMap.get("ORD_SEQ");
			
			/* 수량이 없으면 SKIP한다 */
			ls_req_qty          = processMap.get("OUT_QTY").toString();
			
			/* 협력사 출고 */
			processMap.put("PROCESS_MODE", "OUT");
			processMap.put("OUT_DATE"    , ls_out_date);
			
			if (ls_req_qty == null || ls_req_qty.length() == 0) {
               continue;
			} 			
			
			if (ORD_SEQ == null ||  ORD_SEQ.toString().length() == 0   ) {
				crud = "C";
				logger.debug(" ORD_SEQ  == null crud  ==> " + crud);
			} 
			logger.debug(" crud  ==> " + crud);

			if(crud != null) {
				 processMap.put("PARAM_PROGRM", "updateOrderGoods");
				 orderRequestDao.updateReqGoodsTmp(processMap);
				 proces_cnt += 1;
			}
		}
		
		return proces_cnt;
		
	}
	
	@Override
	public int insertSelectTMPtoPurOrd(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insertSelectTMPtoPurOrdGoods(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}
	
	@Override
	public int updatePurordAmount(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}
	
	@Override
	public Map<String, Object> getPurCurrentOrdSeq(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderRequestDao.getPurCurrentOrdSeq(paramMap);
	}	

	@Override
	public String getPurExtractOrdSeq(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderRequestDao.getPurExtractOrdSeq(paramMap);
	}	
	
	@Override
	public int updateReqGoodsTmpStatus(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}
	
	/**
	  * insertSelectTempToOrder -  발주TMP에서 발주서마스터 및 상세로 INSERT
	  * @author 손경락
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  * 
	  * 1. 조회시  협력업채단위로  sorting
	  * 2. Loop돌리면서( 저장 상태인 인것만 저장처리 => 화면에서 걸러서 온다 )
	  * 3. 발주서상세 Insert 
	  * 4. 발주서상세 상태,납기정일Update
	  * 5. 발주서마스터 Insert
	  * 
	  */
	@ Transactional
	@Override
	public int  insertSelectTempToOrder(List<Map<String, Object>> paramMapList) throws SQLException, Exception {
	   int    resultInt  = 0;
	   int    select_cnt = 0;
	   long   ll_tot_amt = 0;
	   long   ll_tmp_amt = 0;
	   
	   String ls_req_date = "";
	   String ls_req_custmr_cd  = "";
	   String ls_ord_seq = "";
	   String cm_ord_seq = "";

	   String ls_ord_type = "";
	   String cm_ord_type = "";
	   
	   String ls_resp_user = "";
	   String ls_mode = "";
	   String ls_orgn_div = "";

	   String temp_supl_custmr_cd  = "";
	   String curr_supl_custmr_cd  = "";
	   String OrderNumber = "";
	   String OrderState  = "";
	   String WmsState = "";
	   String ls_orgn_div_cd = "";
	   String ls_orgn_cd  = "";
	   String ls_out_date  = "";    /* 출고예정일 */
	   String ls_res_date  = "";    /* 납기예정일 */
       String ls_ord_state = "";
       String ls_FLAG = "";
	   String ls_IO_SW = "";        /* 일반발주 완료상태(3), 지영점긴급발주 승인대기(2), 취급점 긴급발주 영업승인상태(4) */
	   String ls_RET_YN = "";
	   
	   Map<String, Object> parameterMap = new HashMap<String, Object>();
	   Map<String, Object> paramMap     = new HashMap<String, Object>();
		
       for(Map<String, Object> processMap : paramMapList){
    	   
			/* ※ 2020-01-07 아주중요 발주예정건만 처리한다 */
			ls_FLAG  = processMap.get("FLAG").toString(); 
			if ( !"1".equals(ls_FLAG) )  continue;		
					
    	    ls_ord_seq          = processMap.get("ORD_SEQ").toString();
		 	curr_supl_custmr_cd = processMap.get("SUPR_CUSTMR_CD").toString();
			ls_req_date         = processMap.get("REQ_DATE").toString();
			ls_req_custmr_cd    = processMap.get("REQ_CUSTMR_CD").toString();
			ls_orgn_div_cd      = processMap.get("ORGN_DIV_CD").toString();
			ls_resp_user        = processMap.get("RESP_USER").toString();
			ls_orgn_cd          = processMap.get("ORGN_CD").toString();
			ls_orgn_div         = processMap.get("ORGN_DIV_CD").toString().substring(0, 1);
			ls_ord_type         = processMap.get("ORD_TYPE").toString();
					    
			ll_tmp_amt          = Long.parseLong(processMap.get("TOT_AMT").toString()); 
			/*  Long.parseLong(processMap.get("COMP_TOT_AMT").toString()); */
			ll_tot_amt          = ll_tot_amt + ll_tmp_amt;
			   
		    logger.debug("@@@@@@@@ Step1 ls_orgn_div => " + ls_orgn_div );
			
		    parameterMap.put("ORGN_DIV_CD"  , ls_orgn_div_cd);
		    parameterMap.put("ORGN_CD"      , ls_orgn_cd);
		    parameterMap.put("SUPR_CD"      , curr_supl_custmr_cd);
		    parameterMap.put("PARAM_ORD_NO" , ls_req_date + "_" + ls_req_custmr_cd );
		    
			/*******************************************************/
			/*  INSERT할 발주서 마스터 ORD_NO를 구한다             */
			/*******************************************************/
			if ( select_cnt == 0) {
				
			    logger.debug("@@@@@@@@ Step1 ORGN_DIV_CD => " + ls_orgn_div_cd + " ORGN_CD=> "+ls_req_custmr_cd );
			    parameterMap.put("ORD_TYPE"      , ls_ord_type); /* 발주유형 */
			    
			    paramMap  = orderRequestDao.getPurCurrentOrdSeq(parameterMap);

				if(paramMap != null) {
					OrderNumber = paramMap.get("ORD_NO").toString();
					OrderState  = paramMap.get("ORD_STATE").toString();
					WmsState    = paramMap.get("WMS_STATE").toString();
				} else {
					OrderNumber = "";
					OrderState  = "";
					WmsState    = "";
				}

				/******************************************************************************************************************
                 * 납기예정일 구함  
                 *    1물류발주  :  getReservDateWinplus() 호출    직영점,취금점 거래처 기준 배송일자 및 영업일 LEADTIME기준으로 날자를 구한다
                 *    2직납발주  :  getReservDateSuply()호출       공급사 기준 배송일자 및 영업일 LEADTIME기준으로 날자를 구한다
                 *    3신선발주  :  발주일+1일 
                 *    4착지변경  :  ORGN_DIV_CD이 첫째자리로 판단
                 *                  4-1. 센터에서 외부공급사 착지변경 발주이면( ORGN_DIV_CD,1,1 => B)  getReservDateSuply()호출 
                 *                  4-2. 직영점   센터로 칙지변경 발주이면( ORGN_DIV_CD,1,1 => C)  getReservDateWinplus() 호출 
                 *                   
				 ******************************************************************************************************************/
			    parameterMap.put("PARAM_CUST_CD"   , curr_supl_custmr_cd); /* 공급사 */
			    parameterMap.put("PARAM_EMP_NO"    , processMap.get("RESP_USER").toString()); /* 로그인 사용자의 정보 거래처업보에 배송,LEADTIME구한다  */
			    parameterMap.put("PARAM_ORD_DT"    , ls_req_date);         /* 발주일자  */

			    logger.debug("@@@@@@@@  ===============> Step1 =============");			    
				ls_res_date  = processMap.get("RESV_DATE").toString();  
			    logger.debug("@@@@@@@@  ===============> Step2 =============");			    
				
				logger.debug("@@@@@@@@ ls_res_date => " + ls_res_date);
			    logger.debug("@@@@@@@@  ===============> Step3 =============");			    
				
				/***********************************************************************/
				/* 납기예정일자가 없으면 leadtime적용된 예정일을 구한다                */
				/* 센터직납인경우 화면에서 지정된 납기예정일로 처리한다                */
				/***********************************************************************/
	 			if (ls_res_date == null || ls_res_date.length() == 0) {
				    /* PARAM_ORD_PATH(경로) 1센터, 2직영점, 3포털발주, 6긴급발주 */
					if( ls_ord_type.equals("1")){
					    parameterMap.put("PARAM_ORD_PATH" , "1"); 
					    logger.debug("@@@@@@@@ 1물류발주 getReservDateWinplus => ");
					    paramMap  = orderRequestDao.getReservDateWinplus(parameterMap);
					} else if( ls_ord_type.equals("2")){
					    logger.debug("@@@@@@@@ 2직납발주 getReservDateSuply => ");
						paramMap  = orderRequestDao.getReservDateSuply(parameterMap);
					} else if( ls_ord_type.equals("3")){
					    logger.debug("@@@@@@@@ 3신선발주 getReservDateSuply => ");
					    parameterMap.put("PARAM_CUST_CD"   , "");
					    parameterMap.put("PARAM_EMP_NO"    , "");
					    paramMap  = orderRequestDao.getReservDateSuply(parameterMap);
					} else if( ls_ord_type.equals("4")){
	                    /* 센터에서 외부공급사 발주  */					
						if ( ls_orgn_div_cd.substring(0,1).equals("B") ) {
						    logger.debug("@@@@@@@@ 4착지변경 외부 getReservDateWinplus => ");
							paramMap  = orderRequestDao.getReservDateSuply(parameterMap);
						}  else
						{
						    parameterMap.put("PARAM_ORD_PATH" , "1"); 
						    logger.debug("@@@@@@@@ 4착지변경 센터 getReservDateWinplus => ");
							paramMap  = orderRequestDao.getReservDateWinplus(parameterMap);
						}
					} else if( ls_ord_type.equals("5")) {
					    parameterMap.put("PARAM_ORD_PATH" , "1"); 
					    logger.debug("@@@@@@@@ 5일배발주 getReservDateWinplus => ");
					    paramMap  = orderRequestDao.getReservDateWinplus(parameterMap);
					} else if( ls_ord_type.equals("6")) {
					    parameterMap.put("PARAM_ORD_PATH" , "6"); 
					    logger.debug("@@@@@@@@ 6긴급발주 getReservDateWinplus => ");
					    paramMap  = orderRequestDao.getReservDateWinplus(parameterMap);
					} else if( ls_ord_type.equals("A")) {
					    logger.debug("@@@@@@@@ A구매반품(센터 외부공급사) getReservDateSuply => ");
						paramMap  = orderRequestDao.getReservDateSuply(parameterMap);
					} else if( ls_ord_type.equals("B")) {
					    logger.debug("@@@@@@@@ B구매반품(직영점직반건) getReservDateSuply => ");
						paramMap  = orderRequestDao.getReservDateSuply(parameterMap);
				    } else   {
					    parameterMap.put("PARAM_ORD_PATH" , "1"); 
					    logger.debug("@@@@@@@@ 기타반품 모두 센터로  getReservDateWinplus => ");
					    paramMap  = orderRequestDao.getReservDateWinplus(parameterMap);
				    }

					if(paramMap != null) {
						ls_out_date  = paramMap.get("OUT_PLN_DT").toString();  /* 출고예정일 */
						ls_res_date  = paramMap.get("RESV_DATE").toString();   /* 납기예정일 */
					} else {
						ls_out_date  = "";
						ls_res_date  = "";
					}
					
	 			} else {
	 				ls_out_date  = processMap.get("RESV_DATE").toString();       
					ls_res_date  = processMap.get("RESV_DATE").toString();       
	 			}
	 			
			    logger.debug("@@@@@@@@ Step0  ls_out_date => " + ls_out_date + " ls_res_date=>"+ls_res_date);
				
			    parameterMap.put("RESV_DATE"     , ls_res_date);       /* 납기예정일 */
			    parameterMap.put("OUT_DATE"      , ls_out_date);       /* 출고예정일 */
			    
			    paramMap  = orderRequestDao.getPurCurrentOrdSeq(parameterMap);
				
			    logger.debug("@@@@@@@@ Step1 OrderNumber => " + OrderNumber + " OrderState=>"+OrderState);
				if (OrderNumber == null || OrderNumber.length() == 0) {
					OrderNumber =  orderRequestDao.getPurExtractOrdSeq(parameterMap);
					ls_mode     = "INSERT";
				}   else {
					
					if( ls_ord_type.equals("6")){
						if( ls_orgn_div.equals("C")){
							ls_IO_SW = "4";             /* 영업승인된 상태(물류승인대상) */
						} else {
							ls_IO_SW = "2";             /* 승인대기상태로  */
						}
					} else
					{
						ls_IO_SW = "3";                 /* 주문완료 */
					}
					
					/************************************************************************************/
					/* 1. 일반주문인경우                                                                */ 
					/*    주문완료(3) 상태 이면 기존 ORD_NO에다 발주마스터는Update/상세는 Insert한다    */
					/*    ELSE 출고요청이면 신규 ORD_NO                                                 */
					/* 2. 직졍점 긴급주문인경우                                                         */
					/*    영업승인(4) 상태 이면 기존 ORD_NO에다 발주마스터는Update/상세는 Insert한다    */
					/*    ELSE 출고요청이면 신규 ORD_NO                                                 */
					/* 3. 취급점 긴급주문인경우                                                         */
					/*    승인대기(2) 상태 이면 기존 ORD_NO에다 발주마스터는Update/상세는 Insert한다    */
					/*    ELSE 출고요청이면 신규 ORD_NO                                                 */
					/************************************************************************************/
					switch (WmsState)  {
							case "03" : OrderNumber =  orderRequestDao.getPurExtractOrdSeq(parameterMap);  /* WMS송신완료 */
										ls_mode     = "INSERT";
										break;
							case "05" : OrderNumber =  orderRequestDao.getPurExtractOrdSeq(parameterMap);  /* WMS수신완료 */
							            ls_mode     = "INSERT";
							            break;
							default   :
								
										if(!OrderState.equals( ls_IO_SW )){
											OrderNumber =  orderRequestDao.getPurExtractOrdSeq(parameterMap);
											ls_mode     = "INSERT";
										} else {
											ls_mode     = "UPDATE";
										}
					}
					
				}
			    logger.debug("@@@@@@@@ Step2 OrderNumber => " + OrderNumber + " OrderState=>"+OrderState + "PUR_ORD_PROCESS_MODE=> " + ls_mode);

				/* 발주서 order번호구하기 나중에 DB SEQUENCE(IDENTITY) 처리시 뺄것 */ 
				temp_supl_custmr_cd = curr_supl_custmr_cd;
				cm_ord_seq  = ls_ord_seq;
				cm_ord_type = ls_ord_type;
				select_cnt++;
			}
			
		    parameterMap.put("ORGN_DIV_CD"    , ls_orgn_div_cd);
		    parameterMap.put("ORGN_CD"        , ls_orgn_cd);        /* 요청조직은 동일함 */

		    /* 주문서 처리ORD_NO => 발주를 요청하는 고객사코드로 */
		    if( ls_mode.equals("INSERT")){
			    parameterMap.put("ORD_NO"     , ls_req_date+"_"+ls_req_custmr_cd +"_"+OrderNumber);      
		    } else {
			    parameterMap.put("ORD_NO"     , OrderNumber);      
		    }
		    
		    parameterMap.put("DELI_DATE"      , ls_res_date);     /* 납기예정*/
		    parameterMap.put("REQ_DATE"       , ls_req_date);
		    parameterMap.put("RESP_USER"      , ls_resp_user);
		    parameterMap.put("SUPR_CD"        , temp_supl_custmr_cd); /* 직전공급사(협력사) */
		    parameterMap.put("REQ_CUSTMR_CD"  , ls_req_custmr_cd );
		    
		    /* 발주요청을 읽기위함 ORD_NO는 발주일자 + 요청거래처코드 */
		    parameterMap.put("PARAM_ORD_NO"   , processMap.get("ORD_NO").toString());      
		    
		    /**********************************************************************************************/
		    /* 공급사가 바뀐경우                                                                          */    
			/* 1. 발주마스터 INSERT or Udate                                                              */
			/* 2. 발주번호 다시구함                                                                       */
			/**********************************************************************************************/
			if(  (!curr_supl_custmr_cd.equals(temp_supl_custmr_cd)) || (!ls_ord_type.equals(cm_ord_type))  ){
                
			    logger.debug("OrderRequestServiceImpl.java ######## 두번째 row주터 curr_supl_custmr_cd != temp_supl_custmr_cd or ls_ord_type != ls_ord_type"  );
				if(ls_mode.equals("INSERT")){
					
					/* 취급점에서의 발주가 아니면 입고창고는 조직코드로  */
					if( ls_orgn_div.equals("Z")){
						parameterMap.put("IN_WARE_CD"   ,ls_req_custmr_cd);
						parameterMap.put("ORD_CUSTMR_CD",ls_req_custmr_cd);
					} else {
						parameterMap.put("IN_WARE_CD"   ,ls_orgn_cd);
						parameterMap.put("ORD_CUSTMR_CD",ls_orgn_cd);
					}
				    parameterMap.put("ORD_SEQ"   , cm_ord_seq);
				    parameterMap.put("ORD_TYPE"  , cm_ord_type);
				    
				    parameterMap.put("ORD_STATE"  , "3");    /* 주문완료 */
					/* 직영점 긴급발주서는  4번( MD승인상태로 )  */
					if( cm_ord_type.equals("6")){
						if( ls_orgn_div.equals("C")){
						    parameterMap.put("ORD_STATE",   "4");     /* 영업승인된 상태(물류승인대상) */
						} else {
						    parameterMap.put("ORD_STATE",   "2");     /* 승인대기상태로  */
						}
					}
				    
					/* 반품여부 처리 */
		            switch (cm_ord_type) {
			            case "1":  parameterMap.put("RETN_YN", "N");  break;
			            case "2":  parameterMap.put("RETN_YN", "N");  break;
			            case "3":  parameterMap.put("RETN_YN", "N");  break;
			            case "4":  parameterMap.put("RETN_YN", "N");  break;
			            case "5":  parameterMap.put("RETN_YN", "N");  break;
			            case "6":  parameterMap.put("RETN_YN", "N");  break;
			            case "7":  parameterMap.put("RETN_YN", "N");  break;
			            default:   parameterMap.put("RETN_YN", "Y");  break;
			        }		
		            
				    resultInt  += orderRequestDao.insertSelectTMPtoPurOrd(parameterMap);
				}  else {
					if( ls_orgn_div.equals("Z")){
						parameterMap.put("SUPR_CD", ls_req_custmr_cd);
					} else {
						parameterMap.put("SUPR_CD", ls_orgn_cd);
					}
				    resultInt  += orderRequestDao.updatePurordAmount(parameterMap);
				}
				
				temp_supl_custmr_cd = curr_supl_custmr_cd;
				cm_ord_seq = ls_ord_seq;
				cm_ord_type = ls_ord_type;

				/******************************************************************************************************/
				/* 바뀐 공급사를 기준으로  ORD_NO를 Sequence를 새로 가져올건이가  발주마스터의 ORD_NO를 쓸것인지 판단 */ 
				/******************************************************************************************************/
			    parameterMap.put("SUPR_CD"      , curr_supl_custmr_cd);
			    parameterMap.put("PARAM_ORD_NO" , ls_req_date + "_" + ls_req_custmr_cd );
			    parameterMap.put("ORD_TYPE"     , ls_ord_type); /* 발주유형 */
			    
				paramMap  = orderRequestDao.getPurCurrentOrdSeq(parameterMap);

				if(paramMap != null) {
					OrderNumber = paramMap.get("ORD_NO").toString();
					OrderState  = paramMap.get("ORD_STATE").toString();
					WmsState    = paramMap.get("WMS_STATE").toString();
				} else {
					OrderNumber = "";
					OrderState  = "";
					WmsState  = "";
				}

			    logger.debug("@@@@@@@@ Step1 OrderNumber => " + OrderNumber + " OrderState=>"+OrderState);
				if (OrderNumber == null || OrderNumber.length() == 0) {
					OrderNumber =  orderRequestDao.getPurExtractOrdSeq(parameterMap);
					ls_mode     = "INSERT";
				}   else {
					
					if( ls_ord_type.equals("6")){
						if( ls_orgn_div.equals("C")){
							ls_IO_SW = "4";             /* 영업승인된 상태(물류승인대상) */
						} else {
							ls_IO_SW = "2";             /* 승인대기상태로  */
						}
					} else
					{
						ls_IO_SW = "3";                 /* 주문완료 */
					}					
					
					/************************************************************************************/
					/* 1. 일반주문인경우                                                                */ 
					/*    주문완료(3) 상태 이면 기존 ORD_NO에다 발주마스터는Update/상세는 Insert한다    */
					/*    ELSE 출고요청이면 신규 ORD_NO                                                 */
					/* 2. 직졍점 긴급주문인경우                                                         */
					/*    영업승인(4) 상태 이면 기존 ORD_NO에다 발주마스터는Update/상세는 Insert한다    */
					/*    ELSE 출고요청이면 신규 ORD_NO                                                 */
					/* 3. 취급점 긴급주문인경우                                                         */
					/*    승인대기(2) 상태 이면 기존 ORD_NO에다 발주마스터는Update/상세는 Insert한다    */
					/*    ELSE 출고요청이면 신규 ORD_NO                                                 */
					/************************************************************************************/
					
					switch (WmsState)  {
					case "03" : OrderNumber =  orderRequestDao.getPurExtractOrdSeq(parameterMap);  /* WMS송신완료 */
								ls_mode     = "INSERT";
								break;
					case "05" : OrderNumber =  orderRequestDao.getPurExtractOrdSeq(parameterMap);  /* WMS수신완료 */
					            ls_mode     = "INSERT";
					            break;
					default   :
						
								if(!OrderState.equals( ls_IO_SW )){
									OrderNumber =  orderRequestDao.getPurExtractOrdSeq(parameterMap);
									ls_mode     = "INSERT";
								} else {
									ls_mode     = "UPDATE";
								}
					}
					
					
				}
			    logger.debug("@@@@@@@@ Step2 OrderNumber => " + OrderNumber + " OrderState=>"+OrderState + "PUR_ORD_PROCESS_MODE=> " + ls_mode);

			    /* 수정(추가) 2019-11-01  주문서 처리ORD_NO => 발주를 요청하는 고객사코드로 */
			    if( ls_mode.equals("INSERT")){
				    parameterMap.put("ORD_NO"     , ls_req_date+"_"+ls_req_custmr_cd +"_"+OrderNumber);      
			    } else {
				    parameterMap.put("ORD_NO"     , OrderNumber);      
			    }				
			    
			    
				/******************************************************************************************************************
                 * 납기예정일 구함  
                 *    1물류발주  :  getReservDateWinplus() 호출    직영점,취금점 거래처 기준 배송일자 및 영업일 LEADTIME기준으로 날자를 구한다
                 *    2직납발주  :  getReservDateSuply()호출       공급사 기준 배송일자 및 영업일 LEADTIME기준으로 날자를 구한다
                 *    3신선발주  :  발주일+1일 
                 *    4착지변경  :  ORGN_DIV_CD이 첫째자리로 판단
                 *                  4-1. 센터에서 외부공급사 착지변경 발주이면( ORGN_DIV_CD,1,1 => B)  getReservDateSuply()호출 
                 *                  4-2. 직영점   센터로 착지변경 발주이면( ORGN_DIV_CD,1,1 => C)  getReservDateWinplus() 호출 
                 *    6긴급발주  :  물류발주 기준                
				 ******************************************************************************************************************/
			    parameterMap.put("PARAM_CUST_CD"   , curr_supl_custmr_cd); /* 공급사 */
			    parameterMap.put("PARAM_EMP_NO"    , processMap.get("RESP_USER").toString()); /* 로그인 사용자의 정보 거래처업보에 배송,LEADTIME구한다  */
			    parameterMap.put("PARAM_ORD_DT"    , ls_req_date);         /* 발주일자  */
			    
			    logger.debug("@@@@@@@@@@@@@@@@@@@@ PARAM_ORD_PATH @@@@@@@@@@@@@@@@@@@@@@@@ ");
			    
			    logger.debug("@@@@@@@@  ===============> Step1 =============");			    
				ls_res_date  = processMap.get("RESV_DATE").toString();  
			    logger.debug("@@@@@@@@  ===============> Step2 =============");			    
				
				logger.debug("@@@@@@@@ ls_res_date => " + ls_res_date);
			    logger.debug("@@@@@@@@  ===============> Step3 =============");			    
				
				/***********************************************************************/
				/* 납기예정일자가 없으면 leadtime적용된 예정일을 구한다                */
				/* 센터직납인경우 화면에서 지정된 납기예정일로 처리한다                */
				/***********************************************************************/
	 			if (ls_res_date == null || ls_res_date.length() == 0) {
				    /* PARAM_ORD_PATH(경로) 1센터, 2직영점, 3포털발주, 6긴급발주 */
					if( ls_ord_type.equals("1")){
					    parameterMap.put("PARAM_ORD_PATH" , "1"); 
					    logger.debug("@@@@@@@@ 1물류발주 getReservDateWinplus => ");
					    paramMap  = orderRequestDao.getReservDateWinplus(parameterMap);
					} else if( ls_ord_type.equals("2")){
					    logger.debug("@@@@@@@@ 2직납발주 getReservDateSuply => ");
						paramMap  = orderRequestDao.getReservDateSuply(parameterMap);
					} else if( ls_ord_type.equals("3")){
					    logger.debug("@@@@@@@@ 3신선발주 getReservDateSuply => ");
					    parameterMap.put("PARAM_CUST_CD"   , "");
					    parameterMap.put("PARAM_EMP_NO"    , "");
					    paramMap  = orderRequestDao.getReservDateSuply(parameterMap);
					} else if( ls_ord_type.equals("4")){
	                    /* 센터에서 외부공급사 발주  */					
						if ( ls_orgn_div_cd.substring(0,1).equals("B") ) {
						    logger.debug("@@@@@@@@ 4착지변경 외부 getReservDateWinplus => ");
							paramMap  = orderRequestDao.getReservDateSuply(parameterMap);
						}  else
						{
						    parameterMap.put("PARAM_ORD_PATH" , "1"); 
						    logger.debug("@@@@@@@@ 4착지변경 센터 getReservDateWinplus => ");
							paramMap  = orderRequestDao.getReservDateWinplus(parameterMap);
						}
					} else if( ls_ord_type.equals("5")){
					    parameterMap.put("PARAM_ORD_PATH" , "1"); 
					    logger.debug("@@@@@@@@ 5일배발주 getReservDateWinplus => ");
					    paramMap  = orderRequestDao.getReservDateWinplus(parameterMap);
					} else if( ls_ord_type.equals("6")){
					    parameterMap.put("PARAM_ORD_PATH" , "6"); 
					    logger.debug("@@@@@@@@ 6긴급발주 getReservDateWinplus => ");
					    paramMap  = orderRequestDao.getReservDateWinplus(parameterMap);
					} else if( ls_ord_type.equals("A")) {
					    logger.debug("@@@@@@@@ A구매반품(센터 외부공급사) getReservDateSuply => ");
						paramMap  = orderRequestDao.getReservDateSuply(parameterMap);
					} else if( ls_ord_type.equals("B")) {
					    logger.debug("@@@@@@@@ B구매반품(직영점직반건) getReservDateSuply => ");
						paramMap  = orderRequestDao.getReservDateSuply(parameterMap);
				    } else   {
					    parameterMap.put("PARAM_ORD_PATH" , "1"); 
					    logger.debug("@@@@@@@@ 기타반품 모두 센터로  getReservDateWinplus => ");
					    paramMap  = orderRequestDao.getReservDateWinplus(parameterMap);
				    }				
					
					if(paramMap != null) {
						ls_out_date  = paramMap.get("OUT_PLN_DT").toString();  /* 출고예정일 */
						ls_res_date  = paramMap.get("RESV_DATE").toString();   /* 납기예정일 */
					} else {
						ls_out_date  = "";
						ls_res_date  = "";
					}
	 			} else {
	 				ls_out_date  = processMap.get("RESV_DATE").toString();       
					ls_res_date  = processMap.get("RESV_DATE").toString();       
	 			}
	 			
			    logger.debug("@@@@@@@@ Step10  ls_out_date => " + ls_out_date + " ls_res_date=>"+ls_res_date);
	 			
			    parameterMap.put("RESV_DATE" , ls_res_date);    /* 납기예정일 */
			    parameterMap.put("OUT_DATE"  , ls_out_date);    /* 출고예정일 */
			    
			}
			
			if( ls_orgn_div.equals("Z")){
				parameterMap.put("ORD_CUSTMR_CD",ls_req_custmr_cd);
			} else {
				parameterMap.put("ORD_CUSTMR_CD",ls_orgn_cd);
			}
			
		    parameterMap.put("ORD_SEQ"        , ls_ord_seq);
	    
			resultInt  += orderRequestDao.insertSelectTMPtoPurOrdGoods(parameterMap);

		    parameterMap.put("FLAG",           "3");                              /* 요청상태 주문완료*/
			/* 직영점 긴급발주서는  4번( MD승인상태로 )  */
			if( ls_ord_type.equals("6")){
				if( ls_orgn_div.equals("C")){
				    parameterMap.put("FLAG",   "4");                              /* 영업승인된 상태(물류승인대상) */
				} 
			}
		    parameterMap.put("PARAM_PROGRM",   "OrderRequestServiceImpl.java");   /* 프로그램 */
		    parameterMap.put("REG_ID",         "ls_resp_user.java");              /* 작업자 */
		    
			resultInt  += orderRequestDao.updateReqGoodsTmpStatus(parameterMap);
			
		}
       
        /*   최종건 발주마스터 insert */ 
        if ( select_cnt > 0 ) {
		    logger.debug(" OrderRequestServiceImpl.java 최종  ");
        	
			/* 반품여부 처리 */
            switch (cm_ord_type) {
	            case "1":  parameterMap.put("RETN_YN", "N");  break;
	            case "2":  parameterMap.put("RETN_YN", "N");  break;
	            case "3":  parameterMap.put("RETN_YN", "N");  break;
	            case "4":  parameterMap.put("RETN_YN", "N");  break;
	            case "5":  parameterMap.put("RETN_YN", "N");  break;
	            case "6":  parameterMap.put("RETN_YN", "N");  break;
	            case "7":  parameterMap.put("RETN_YN", "N");  break;
	            default:   parameterMap.put("RETN_YN", "Y");  break;
	        }			
		    
			if(ls_mode.equals("INSERT")){
				/* 취급점에서의 발주가 아니면 입고창고는 조직코드로  */
				if( ls_orgn_div.equals("Z")){
					parameterMap.put("IN_WARE_CD"   ,ls_req_custmr_cd);
					parameterMap.put("ORD_CUSTMR_CD",ls_req_custmr_cd);
				} else {
					parameterMap.put("IN_WARE_CD"   ,ls_orgn_cd);
					parameterMap.put("ORD_CUSTMR_CD",ls_orgn_cd);
				}
			    parameterMap.put("ORD_SEQ"   , cm_ord_seq);
			    parameterMap.put("ORD_TYPE"  , cm_ord_type);

			    parameterMap.put("ORD_STATE" , "3");			    
				/* 직영점 긴급발주서는  4번( MD승인상태로 )  */
				if( cm_ord_type.equals("6")){
					if( ls_orgn_div.equals("C")){
					    parameterMap.put("ORD_STATE",   "4");                              /* 영업승인된 상태(물류승인대상) */
					} 
				}
			    
			    resultInt  += orderRequestDao.insertSelectTMPtoPurOrd(parameterMap);
			}  else {
				if( ls_orgn_div.equals("Z")){
					parameterMap.put("SUPR_CD",ls_req_custmr_cd);
				} else {
					parameterMap.put("SUPR_CD",ls_orgn_cd);
				}
			    resultInt  += orderRequestDao.updatePurordAmount(parameterMap);
			}			
			
		    ls_RET_YN = parameterMap.get("RETN_YN").toString();

		    /* 취급점에서의 발주가 아니면 입고창고는 조직코드로  */
			if( ls_orgn_div.equals("Z")){		
				
				/* 반품예정건은 여신반영 하지않는다(발주건만 처리) */
				if( ls_RET_YN.equals("N")){		
			        /*  여신반영할 금액 */		
				    logger.debug("@@@@@@@@ Step1 ls_orgn_div => " + ls_orgn_div  + " tot_amt =>" + ll_tot_amt);
			    
				    parameterMap.put("PARAM_OBJ_CD"  , ls_req_custmr_cd);
				    parameterMap.put("DEAL_AMT"      , ll_tot_amt);   /* 여신 잔액 */
				    ll_tot_amt = ll_tot_amt * -1;
				    parameterMap.put("INDE_AMT"      , ll_tot_amt);   /* 여신 증감액 */
				    resultInt  += orderRequestDao.insertTstdMastCreditLoan(parameterMap);
				}
			}
			
        }
       
		return 0;
		
	}
	
}
