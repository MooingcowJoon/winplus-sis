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

import com.samyang.winplus.sis.order.dao.OrderInputGridPopupDao;
import com.samyang.winplus.sis.order.service.OrderInputGridPopupService;

@Service("OrderInputGridPopupService")
public class OrderInputGridPopupServiceImpl implements OrderInputGridPopupService {
	
	@Autowired
	OrderInputGridPopupDao orderInputGridPopupDao;
	
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
		String OrderNumber = orderInputGridPopupDao.GetOrderNumber(paramMap);
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
					resultInt  += orderInputGridPopupDao.insertTpurOrdGoods(processMap);
					proces_cnt += 1;
				} else if ("U".equals(crud)){
					processMap.put("PARAM_PROGRM", "updateOrderGoods");
					resultInt  += orderInputGridPopupDao.updateTpurOrdGoods(processMap);
					proces_cnt += 1;
				} else if ("D".equals(crud)){
					resultInt += orderInputGridPopupDao.deleteTpurOrdGoods(processMap);
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
				resultInt2  += orderInputGridPopupDao.updateTpurOrd(paramMap);
			}
			else  /*  발주서 Order번호가 없으면 마스터 INSERT */
			{
				
				paramMap.put("ORD_NO" , OrderNumber );   /* 발주서 order번호구하기 나중에 DB SEQUENCE(IDENTITY) 처리시 뺄것  */
				
				paramMap.put("PARAM_PROGRM", "insertOrderGoods");
				resultInt2  += orderInputGridPopupDao.insertTpurOrd(paramMap);
			}
		}
		else
		{
			/*  발주서 Order번호가 존재하면 마스터 Update */
			if( null  != ls_ord_no && ls_ord_no != ""){
				paramMap.put("PARAM_PROGRM", "insertOrderGoods");
				resultInt2  += orderInputGridPopupDao.updateTpurOrd(paramMap);
			}
		}
		
		resultMap.put("resultInt", resultInt);
		resultMap.put("resulOrderNumber", OrderNumber);
		
		return resultMap;
		
	}

	@Override
	public String GetOrderNumber(Map<String, Object> paramMap) throws SQLException, Exception {
		return orderInputGridPopupDao.GetOrderNumber(paramMap);
	}	
	
	@Override
	public int getTpurOrdCount(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderInputGridPopupDao.getTpurOrdCount(paramMap);
	}

	/* 상품가격정보에서 최저가 가져오기 */
	@Override
	public List<Map<String, Object>> getSearchMasterBarcodePriceList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderInputGridPopupDao.getSearchMasterBarcodePriceList(paramMap);
	}
	
	/* PDA수신리스트를 기준으로 최저가 가져오기 */
	@Override
	public List<Map<String, Object>> getSearchPdaOrderBarcodePriceList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderInputGridPopupDao.getSearchPdaOrderBarcodePriceList(paramMap);
	}
	
	/* 주문서복사용 주문서기준으로 현재 센터 최저가적용후 가져오기 */
	@Override
	public List<Map<String, Object>> getSearchOrderDetailListCopy2(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderInputGridPopupDao.getSearchOrderDetailListCopy2(paramMap);
	}
	
	/* 거래처포털  바코드 전문(취급)점 센터주문 최저가 가져오기) */
	@Override
	public List<Map<String, Object>> getSearchMasterBarcodeCustmrPriceList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderInputGridPopupDao.getSearchMasterBarcodeCustmrPriceList(paramMap);
	}

	/**
	  * 거래처포털 센터주문 상품기준 최저 구매가격 가져오기
	  * @author 손경락
	  * @param request
	  * @return List
	  * @throws SQLException
	  * @throws Exception
	  */		
	@Override
	public List<Map<String, Object>> getSearchMasterBarcodeCustomerLowestPriceList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderInputGridPopupDao.getSearchMasterBarcodeCustomerLowestPriceList(paramMap);
	}

	/**
	  * 거래처포털 교한반품 최저가 가져오기
	  * @author 손경락
	  * @param request
	  * @return List
	  * @throws SQLException
	  * @throws Exception
	  */		
	@Override
	public List<Map<String, Object>> getReturnMasterBarcodeLowestPriceList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderInputGridPopupDao.getReturnMasterBarcodeLowestPriceList(paramMap);
	}

	/**
	  * cs포털 일반반품 최저가 가져오기
	  * @author 손경락
	  * @param request
	  * @return List
	  * @throws SQLException
	  * @throws Exception
	  */		
	@Override
	public List<Map<String, Object>> getBanpumBarcodePriceList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderInputGridPopupDao.getBanpumBarcodePriceList(paramMap);
	}
	
	/**
	  * 직영점 센터반품건의 최저구매가격 가져오기
	  * @author 손경락
	  * @param request
	  * @return List
	  * @throws SQLException
	  * @throws Exception
	  */		
	@Override
	public List<Map<String, Object>> getBanpumMkBarcodePriceList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderInputGridPopupDao.getBanpumMkBarcodePriceList(paramMap);
	}

	/**
	  * 직발 반품건의 최저구매가격 가져오기
	  * @author 손경락
	  * @param request
	  * @return List
	  * @throws SQLException
	  * @throws Exception
	  */		
	@Override
	public List<Map<String, Object>> getBanpumOutBarcodePriceList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderInputGridPopupDao.getBanpumOutBarcodePriceList(paramMap);
	}
	
	/**
	  * 센터 착지변경 2차발주 대상 및 최저가 가져오기
	  * @author 손경락
	  * @param request
	  * @return List
	  * @throws SQLException
	  * @throws Exception
	  */	
	@Override
	public List<Map<String, Object>> getSearchCHGOrderBarcodePriceList(Map<String, Object> paramMap)  throws SQLException, Exception {
		return orderInputGridPopupDao.getSearchCHGOrderBarcodePriceList(paramMap);
	}

	

	/**
	  * 발주관련(발주유형 전체)  입/출고 예정정보를 WMS로 전송한다( 인수인계 문서 WMS인터페이스 참조)
	  * @author 손경락
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Transactional
	@Override
	public Map<String, Object> SP_WMS_SEND_ORD_SALE(List<Map<String, Object>> paramMapList ) throws SQLException, Exception {	     

		Map<String, Object> resultMap  = new HashMap<String, Object>();

		int    resultInt  = 0;
		String ls_date    = "";
		String ls_ord_no  = "";
		String ls_ord_type = "";
		String ls_orgn_div = "";
		
		/* 입고예정건은 SP_WMS_SEND_ONLINE_ORD이게 아니라  
		 *   orderInputGridPopup.xml 내부에서
		 *   EXEC SP_WMS_SEND_PUR @PARAM_DATE,@PARAM_ORD_NO로 호출한다    */
		for(Map<String, Object> processMap : paramMapList){
	       
			ls_date     = processMap.get("REQ_DATE").toString();
			ls_ord_no   = processMap.get("ORD_NO").toString();
			ls_ord_type = processMap.get("PARAM_ORD_TYPE").toString();
			ls_orgn_div = processMap.get("ORGN_DIV_TYP").toString();   /* 조직영역 :  A본사, B물류센터, C직영점  Z취급점  */
			
		    if ("A".equals(ls_orgn_div))  ls_orgn_div = "B";
			
			logger.debug("@@@ Date => "+ ls_date + " ORD_NO =>"  + ls_ord_no + " PARAM_ORD_TYPE =>" + ls_ord_type + " ORGN_DIV_TYP =>" + ls_orgn_div);

			switch(ls_ord_type) {	
			        case "1" :  resultInt  += orderInputGridPopupDao.SP_WMS_SEND_ORD_SALE(processMap);    /*  물류발주 => 출고예정*/
			                    break;
			        case "2" :  
			        			if("B".equals(ls_orgn_div)){
			        				resultInt  += orderInputGridPopupDao.SP_WMS_SEND_ONLINE_ORD(processMap);  /* 직납발주(센터건만) => 입고예정  */
			        			}
			        			break;
			        			
			        case "3" :  continue;    /* 신선발주 => SKIP */
			        case "4" :  continue;    /* 착지변경 => SKIP */
			        
			        case "5" :  
  						        if("B".equals(ls_orgn_div)){
  						        	resultInt  += orderInputGridPopupDao.SP_WMS_SEND_ONLINE_ORD(processMap);  /* 일배발주(센터건만) =>  입고예정     */
  						        }
  						        
  						        if("C".equals(ls_orgn_div)){
  				                    resultInt  += orderInputGridPopupDao.SP_WMS_SEND_ORD_SALE(processMap);    /* 일배발주(직영점) => 출고예정 */
  						        }
  						        if("Z".equals(ls_orgn_div)){
  				                    resultInt  += orderInputGridPopupDao.SP_WMS_SEND_ORD_SALE(processMap);    /* 일배발주(취급점) => 출고예정 */
  						        }
			        		    break;
			        		    
			        case "6" :  resultInt  += orderInputGridPopupDao.SP_WMS_SEND_ORD_SALE(processMap);    /* 긴급발주(물류발주 시간경과건) => 출고예정 */
                                break;
                                
			        case "7" :  resultInt  += orderInputGridPopupDao.SP_WMS_SEND_ORD_SALE(processMap);    /* 사내소비 => 출고예정 */
                                break;
                                
			        case "A" :  resultInt  += orderInputGridPopupDao.SP_WMS_SEND_ORD_SALE(processMap);    /* 구매반품(센터에서 협력사) => 출고예정  */
                                break;
                                
			        case "B" :  continue;   
			        
			        /* 구매반품(직영점에서 직발건 반품) => SKIP */
			        case "C" :  resultInt  += orderInputGridPopupDao.SP_WMS_SEND_ONLINE_ORD(processMap);  /* 구매반품(직영점에서 센터구매건 반품 =>  입고예정 */
			        		 	break;
			        		 	
			        case "D" :  resultInt  += orderInputGridPopupDao.SP_WMS_SEND_ONLINE_ORD(processMap);  /* 판매반품(CS) 전문점/취급점에서 센터구매건  반품 =>  입고예정 */
        		 				break;
        		 				
        		 	/* 교환은 입/출고 예정정보 전체다 필요함 */
			        case "E" :  resultInt  += orderInputGridPopupDao.SP_WMS_SEND_ONLINE_ORD(processMap);  /* 교환반품CS)  전문점/귀급점 주문건의 교환  */
			                    resultInt  += orderInputGridPopupDao.SP_WMS_SEND_ORD_SALE(processMap);    /*  물류발주 */
        		 				break;
        		 				
			        default:    break;
			}
	     }

		resultMap.put("resultInt", resultInt);
		
		return resultMap;
	}
	
	
	/**
	  * 발주(주문)관리  입고예정 정보를 WMS로 전송한다
	  * @author 손경락
	  * @param request
	  * @return Integer
	  * @throws SQLException
	  * @throws Exception
	  */
	@Override
	public int SP_WMS_SEND_ONLINE_ORD(Map<String, Object> paramMap) throws SQLException, Exception {
		return orderInputGridPopupDao.SP_WMS_SEND_ONLINE_ORD(paramMap);
	}
	
	@Override
	public int SP_WMS_SEND_ORD_SALE(Map<String, Object> paramMap) throws SQLException, Exception {
		return 0;
	}	
	
	
}
