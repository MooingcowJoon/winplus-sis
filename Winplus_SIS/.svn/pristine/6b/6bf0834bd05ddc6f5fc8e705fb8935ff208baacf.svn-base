<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglib.jspf" %>
<link rel="stylesheet" href="/resources/common/css/default.css?ver=20181127_01" />
<%-- 테마 적용을 위한 분리 --%>
<c:if test="${empSessionDto == null }">
<link rel="stylesheet" href="/resources/framework/theme/default/common.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxgrid_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxcombo_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxmessage_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxcalendar_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxtabbar_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxlayout_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxtree_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxtreeview_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxribbon_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxwindows_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxtoolbar_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxpopup_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxvault_dhx_skyblue.css"/>  
<link rel="stylesheet" href="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxForm/codebase/skins/dhtmlxform_dhx_skyblue.css"/>  
<link rel="stylesheet" href="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxMenu/codebase/skins/dhtmlxmenu_dhx_skyblue.css"/>  

</c:if>
<c:if test="${empSessionDto != null}">
<link rel="stylesheet" href="/resources/framework/theme/default/common.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxgrid_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxcombo_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxmessage_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxcalendar_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxtabbar_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxlayout_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxtree_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxtreeview_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxribbon_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxwindows_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxtoolbar_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxpopup_dhx_skyblue.css" />
<link rel="stylesheet" href="/resources/framework/theme/default/dhtmlxvault_dhx_skyblue.css"/>
<link rel="stylesheet" href="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxForm/codebase/skins/dhtmlxform_dhx_skyblue.css"/>  
<link rel="stylesheet" href="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxMenu/codebase/skins/dhtmlxmenu_dhx_skyblue.css"/>  
</c:if>


<%-- JavaScript Common Library --%>
<script type="text/javascript" src="/resources/common/js/jquery/jquery-3.1.1.min.js"></script>
<script type="text/javascript" src="/resources/common/js/jquery/jquery.color-2.1.2.min.js"></script>  
<script type="text/javascript" src="/resources/common/js/jquery/jquery.serialize-object.min.js"></script>
<script type="text/javascript" src="/resources/common/js/jquery/autoNumeric.min.js"></script>
<script type="text/javascript" src="/resources/common/js/erp_common.js?ver=20181121.01"></script>
<script type="text/javascript" src="/resources/common/js/erp_popup.js?ver=20181121.01"></script>
<script type="text/javascript" src="/resources/common/js/jquery/pgpopup_2.0.js"></script>
<script type="text/javascript" src="/resources/common/js/contextMenu.js?ver=20190807.01"></script>

<%-- JavaScript Library For Skin --%>
<script type="text/javascript" src="/resources/common/js/erp_header.js?ver=20181129.01"></script>
<%-- Dhtmlx UI Framework Javascript Source Library --%>
<%-- DhtmlxCommon --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxCommon/codebase/dhtmlxcommon.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxCommon/codebase/dhtmlxcore.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxCommon/codebase/dhtmlxcontainer.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxCommon/codebase/dhtmlxdataprocessor.js"></script>
<%-- DhtmlxGrid --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/dhtmlxgrid.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_filter.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_splt.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_srnd.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_json.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_selection.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_nxml.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_rowspan.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_keymap.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_math.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_mcol.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_group.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_fast.js"></script>
<%-- DhtmlxGrid Excells --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_cntr.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_dhxcalendar.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_combo.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_popup.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_robp.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_ro_txt.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_record.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_sub_row.js"></script>
<%-- DhtmlxCombo --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxCombo/codebase/dhtmlxcombo.js"></script>
<%-- DhtmlxWindows --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxWindows/codebase/dhtmlxwindows.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxWindows/codebase/ext/dhtmlxwindows_resize.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxWindows/codebase/ext/dhtmlxwindows_menu.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxWindows/codebase/ext/dhtmlxwindows_dnd.js"></script>
<%-- DhtmlxMessage --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxMessage/codebase/dhtmlxmessage.js"></script>
<%-- DhtmlxCalendar --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxCalendar/codebase/dhtmlxcalendar.js"></script>
<%-- DhtmlxTabbar --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTabbar/codebase/dhtmlxtabbar.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTabbar/codebase/dhtmlxtabbar_start.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTabbar/codebase/dhtmlxtabbar_deprecated.js"></script>
<%-- DhtmlxLayout --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxLayout/codebase/dhtmlxlayout.js?ver=20181127_01"></script>
<%-- DhtmlxTree --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTree/codebase/dhtmlxtree.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTree/codebase/ext/dhtmlxtree_json.js"></script>
<%-- DhtmlxTreeView --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTreeView/codebase/dhtmlxtreeview.js"></script>
<%-- DhtmlxTreeGrid --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTreeGrid/codebase/dhtmlxtreegrid.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTreeGrid/codebase/ext/dhtmlxtreegrid_filter.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTreeGrid/codebase/ext/dhtmlxtreegrid_lines.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTreeGrid/codebase/ext/dhtmlxtreegrid_property.js"></script>
<%-- DhtmlxRibbon --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxRibbon/codebase/dhtmlxribbon.js"></script>
<%-- DhtmlxToolbar --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxToolbar/codebase/dhtmlxtoolbar.js"></script>
<%-- DhtmlxPopup --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxPopup/codebase/dhtmlxpopup.js"></script>
<%-- DhtmlxVault --%>
<script type="text/javascript" src="/resources/framework/dhtmlxVault_v241_pro/sources/dhtmlxVault/codebase/dhtmlxvault.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxVault_v241_pro/sources/dhtmlxVault/codebase/ext/dhtmlxvault_dnd.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxVault_v241_pro/sources/dhtmlxVault/codebase/ext/dhtmlxvault_progress.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxVault_v241_pro/sources/dhtmlxVault/codebase/ext/dhtmlxvault_records.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxVault_v241_pro/sources/dhtmlxVault/codebase/swfobject.js"></script>
<%-- DhtmlxForm --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxForm/codebase/dhtmlxform.js"></script>
<%-- DhtmlxMenu --%>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxMenu/codebase/dhtmlxmenu.js"></script>
<script type="text/javascript" src="/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxMenu/codebase/ext/dhtmlxmenu_ext.js"></script>
