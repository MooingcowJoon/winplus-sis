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

import com.samyang.winplus.sis.order.dao.OrderInputDao;
import com.samyang.winplus.sis.order.service.OrderInputService;
import com.samyang.winplus.sis.order.dao.OrderRequestDao;

@Service("OrderInputService")
public class OrderInputServiceImpl implements OrderInputService {
	
	@Autowired
	OrderInputDao orderInputDao;
	
	@Autowired
	OrderRequestDao orderRequestDao;	
	
	private final Logger logger = LoggerFactory.getLogger(getClass());

	@Override
	public int insertTpurOrd(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insertTpurOrdGoods(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}
	
	@Override
	public int updateTpurOrd(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}
	
	@Override
	public int updateTpurOrdGoods(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int deleteTpurOrd(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}	
	

	@Override
	public int deleteTpurOrdGoods(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}	

	@Override
	public int deleteTpurOrdByCancel(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}	
	
	@Override
	public int deleteTpurOrdGoodsByCancel(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}	
	

	
	/**
	  * saveTpurOrdGoodsScreenList -  발주서마스터 및 상세 C,U,D
	  * @author 손경락
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  * 
	  * 1. 발주서마스터상세가 Insert될경우 발주서마스터는 insert or Update 
	  * 2. 발주서마스터상세가 Update될경우 발주서마스터는 Update 될수있음
	  * 3. 발주사마스터상세가 Delete될경우 발주서마스터는 Update 
	  * 
	  */
	@Transactional
	@Override
	public Map<String, Object>  saveTpurOrdGoodsScreenList(List<Map<String, Object>> paramMapList, Map<String, Object> paramMap) throws SQLException, Exception {
		int resultInt  = 0;
		int resultInt2 = 0;
		int proces_cnt = 0;
		Map<String, Object> resultMap  = new HashMap<String, Object>();

        //logger.debug("@@@@@@@@@@ saveTpurOrdGoodsScreenList.java 발주서상세 처리 ============" );
		String ls_ord_no =  (String) paramMap.get("ORD_NO");
        
		/* 발주서 order번호구하기 나중에 DB SEQUENCE(IDENTITY) 처리시 뺄것 */ 
		String OrderNumber = orderInputDao.GetOrderNumber(paramMap);
		//logger.debug("@@@@@@@@@@  GetOrderNumber  ============"+ OrderNumber );

        for(Map<String, Object> processMap : paramMapList){
			Object crud = processMap.get("CRUD");
			
			if(crud != null) {
				if("C".equals(crud)){

					/* 최초 발주서  작성시만 :  발주서 order번호구하기 나중에 DB SEQUENCE(IDENTITY) 처리시 뺄것  */
					if(ls_ord_no == null || ls_ord_no == ""){
						processMap.put("ORD_NO", OrderNumber);
					}
					
					processMap.put("PARAM_PROGRM", "insertOrderGoods");
					resultInt  += orderInputDao.insertTpurOrdGoods(processMap);
					proces_cnt += 1;
				} else if ("U".equals(crud)){
					processMap.put("PARAM_PROGRM", "updateOrderGoods");
					resultInt  += orderInputDao.updateTpurOrdGoods(processMap);
					proces_cnt += 1;
				} else if ("D".equals(crud)){
					resultInt += orderInputDao.deleteTpurOrdGoods(processMap);
					proces_cnt += 1;
				}
			}
		}
		
		/*  변경분(CUD)이 있으면   */
		if ( resultInt > 0 )
		{
			//logger.debug("@@@@@@@@@@ saveTpurOrdGoodsScreenList.java 발주서마스터 처리  ============" );

			/*  발주서 Order번호가 존재하면 마스터 Update */
			if( null  != ls_ord_no && ls_ord_no != ""){
				/*
				 *  1. 발주일시 : 최초시간을 유지한다므로 updte시 생략 
				 *    UPDATE T_PUR_ORD
				 *    SET    ORD_TITLE        = #{ORD_TITLE       }         발주제목       
				 *         , DELI_DATE        = #{DELI_DATE       }         납기일자       
				 *	       , RESP_USER        = #{RESP_USER       }         담당자코드     
				 *         , SUPR_CD          = #{SUPR_CD         }         협력사코드     
				 *         , PROJ_CD          = #{PROJ_CD         }         프로젝트코드   
				 *         , OUT_WARE_CD      = #{OUT_WARE_CD     }         출하창고코드   
				 *	       , IN_WARE_CD       = #{IN_WARE_CD      }         입고창고코드   
				 *         , MEMO             = #{MEMO            }         메모           
				 *	       , ORD_TYPE         = #{ORD_TYPE        }         발주유형       
				 *	       , ORD_STATE        = #{ORD_STATE       }         발주상태       
				 *	       , RETN_YN          = #{RETN_YN         }         반품여부       
				 *	       , RESN_CD          = #{RESN_CD         }         반품사유코드   
				 *	       , SEND_FAX_STATE   = #{SEND_FAX_STATE  }         펙스발송상태(여부)  
				 *	       , SEND_EMAIL_STATE = #{SEND_EMAIL_STATE}         Email발송상태(여부) 
				 *	       , PRINT_STATE      = #{PRINT_STATE     }         PRINT인쇄상태(여부)  
				 *         , SUPR_AMT         = #{SUPR_AMT        }         공급가액       
				 *         , VAT              = #{VAT             }         부가세         
				 *         , TOT_AMT          = #{TOT_AMT         }         합계금액       
				 *	       , ORD_CUSTMR       = #{ORD_CUSTMR      }         발행구분       			 
				 */
				paramMap.put("PARAM_PROGRM", "insertOrderGoods");
				resultInt2  += orderInputDao.updateTpurOrd(paramMap);
			}
			else  /*  발주서 Order번호가 없으면 마스터 INSERT */
			{
				
				paramMap.put("ORD_NO" , OrderNumber );   /* 발주서 order번호구하기 나중에 DB SEQUENCE(IDENTITY) 처리시 뺄것  */
				
				paramMap.put("PARAM_PROGRM", "insertOrderGoods");
				resultInt2  += orderInputDao.insertTpurOrd(paramMap);
			}
		}
		else
		{
			/*  발주서 Order번호가 존재하면 마스터 Update */
			if( null  != ls_ord_no && ls_ord_no != ""){
				paramMap.put("PARAM_PROGRM", "insertOrderGoods");
				resultInt2  += orderInputDao.updateTpurOrd(paramMap);
			}
		}
		
		resultMap.put("resultInt", resultInt);
		resultMap.put("resulOrderNumber", OrderNumber);
		
		return resultMap;
		
	}

	/**
	  * updateTpurOrdState -  발주서마스터진행상태 Update
	  * @author 손경락
	  * @param paramMapList
	  * @return Integer
	  * @exception SQLException
	  * @exception Exception
	  * 
	  * 1. 발주서 저장후 발주진행상태를 Update한다( 권한자에 한함) 
	  * 
	  */
	@Transactional
	@Override
	public Map<String, Object>  updateTpurOrdState(List<Map<String, Object>> paramMapList ) throws SQLException, Exception {
		int    resultInt  = 0;
		int    proces_cnt = 0;
 	    long   ll_tot_amt = 0;
 	    String ls_orgn_div = "";
		String ls_flag = "";
		String ls_custmr_cd = "";

		Map<String, Object> resultMap  = new HashMap<String, Object>();

       //logger.debug("@@@@@@@@@@ updateTpurOrdState.java 발주서 마스터 진행상태 처리 ============" );

       for(Map<String, Object> processMap : paramMapList){

			processMap.put("PARAM_PROGRM", "updateOrderGoods");

			ls_flag       = processMap.get("FLAG").toString();
			ls_orgn_div   = processMap.get("ORGN_DIV_TYP").toString();
			ls_custmr_cd  = processMap.get("IN_WARE_CD").toString();
			
			/* 발주 취소건은 잔액을 증액해야 하므로  -1 */
			ll_tot_amt   = Long.parseLong(processMap.get("TOT_AMT").toString()) * -1; 

			/*  주문서 관리에서 발주서 취소시 1번으로 치환하여 처리한다 */
			if( ls_flag.equals("2")){
				ls_flag	= "1";
			}
			
			
			if( ls_flag.equals("1")){
				resultInt  += orderInputDao.deleteTpurOrdByCancel(processMap);
				resultInt  += orderInputDao.deleteTpurOrdGoodsByCancel(processMap);

				/*****************************************************/
				/* 취급점에서의 발주취소인 경우 여신잔액을 증액      */
				/*****************************************************/
				if( ls_orgn_div.equals("Z")){			
			        /*  여신반영할 금액 */		
				    //logger.debug("@@@@@@@@ Step1 ls_orgn_div => " + ls_orgn_div  + " tot_amt =>" + ll_tot_amt);
				    processMap.put("PARAM_OBJ_CD"  , ls_custmr_cd);
				    processMap.put("DEAL_AMT"      , ll_tot_amt);   /* 여신 잔액 */
				    ll_tot_amt = ll_tot_amt * -1;
				    processMap.put("INDE_AMT"      , ll_tot_amt);   /* 여신 증감액 */
				    resultInt  += orderRequestDao.insertTstdMastCreditLoan(processMap);
				}
				processMap.put("FLAG", "1");
			} else
			{
	 			processMap.put("PARAM_PROGRM", "updateOrderGoods");
				resultInt  += orderInputDao.updateTpurOrdState(processMap);
			}
			
			processMap.put("PARAM_PROGRM", "updateOrderGoods");
			resultInt  += orderInputDao.updateReqGoodsTmpFlag(processMap);
			
			proces_cnt += 1;
		}
		
		resultMap.put("resultInt", proces_cnt);
		
		return resultMap;
	}
	
	
	
	/**
	  * deleteByORderCancel -  주문서 취소에의한 발주서 삭제
	  * @author 손경락
	  * 
	  */
	@Transactional
	@Override
	public Map<String, Object>  deleteByORderCancel(List<Map<String, Object>> paramMapList ) throws SQLException, Exception {
		int resultInt  = 0;
		int proces_cnt = 0;
		Map<String, Object> resultMap  = new HashMap<String, Object>();

      //logger.debug("@@@@@@@@@@ updateTpurOrdState.java 주문서 취소에의한 발주서 삭제 ============" );

      for(Map<String, Object> processMap : paramMapList){
   	   
			resultInt  += orderInputDao.deleteTpurOrdByCancel(processMap);
			resultInt  += orderInputDao.deleteTpurOrdGoodsByCancel(processMap);

			processMap.put("PARAM_PROGRM", "updateOrderGoods");
			resultInt  += orderInputDao.updateReqGoodsTmpFlag(processMap);
   		
			proces_cnt += 1;
		}
		
		resultMap.put("resultInt", proces_cnt);
		
		return resultMap;
	}
	
	
	@Override
	public String GetOrderNumber(Map<String, Object> paramMap) throws SQLException, Exception {
		return orderInputDao.GetOrderNumber(paramMap);
	}	
	
	@Override
	public int getTpurOrdCount(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderInputDao.getTpurOrdCount(paramMap);
	}

	@Override
	public List<Map<String, Object>> getSearchPdaOrderBarcodePriceList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderInputDao.getSearchPdaOrderBarcodePriceList(paramMap);
	}
	
	@Override
	public int updateTpurOrdState(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}
	
	@Override
	public int updateReqGoodsTmpFlag(Map<String, Object> paramMap) throws SQLException, Exception {
		// TODO Auto-generated method stub
		return 0;
	}
		
}
