/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/9.0.21
 * Generated at: 2021-08-03 01:04:10 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.WEB_002dINF.jsp.common.include;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class default_005fresources_005fheader_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent,
                 org.apache.jasper.runtime.JspSourceImports {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(8);
    _jspx_dependants.put("/WEB-INF/lib/spring-webmvc-5.0.0.RELEASE.jar", Long.valueOf(1555919658000L));
    _jspx_dependants.put("jar:file:/C:/Winplus_SIS_Workspace8/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/Winplus_SIS/WEB-INF/lib/spring-webmvc-5.0.0.RELEASE.jar!/META-INF/spring.tld", Long.valueOf(1506564196000L));
    _jspx_dependants.put("jar:file:/C:/Winplus_SIS_Workspace8/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/Winplus_SIS/WEB-INF/lib/jstl-1.2.jar!/META-INF/fn.tld", Long.valueOf(1153352682000L));
    _jspx_dependants.put("jar:file:/C:/Winplus_SIS_Workspace8/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/Winplus_SIS/WEB-INF/lib/jstl-1.2.jar!/META-INF/c.tld", Long.valueOf(1153352682000L));
    _jspx_dependants.put("/WEB-INF/lib/jstl-1.2.jar", Long.valueOf(1555919670000L));
    _jspx_dependants.put("jar:file:/C:/Winplus_SIS_Workspace8/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/Winplus_SIS/WEB-INF/lib/spring-webmvc-5.0.0.RELEASE.jar!/META-INF/spring-form.tld", Long.valueOf(1506564196000L));
    _jspx_dependants.put("/WEB-INF/jsp/common/include/taglib.jspf", Long.valueOf(1577410167197L));
    _jspx_dependants.put("jar:file:/C:/Winplus_SIS_Workspace8/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/Winplus_SIS/WEB-INF/lib/jstl-1.2.jar!/META-INF/fmt.tld", Long.valueOf(1153352682000L));
  }

  private static final java.util.Set<java.lang.String> _jspx_imports_packages;

  private static final java.util.Set<java.lang.String> _jspx_imports_classes;

  static {
    _jspx_imports_packages = new java.util.HashSet<>();
    _jspx_imports_packages.add("javax.servlet");
    _jspx_imports_packages.add("javax.servlet.http");
    _jspx_imports_packages.add("javax.servlet.jsp");
    _jspx_imports_classes = null;
  }

  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fc_005fif_0026_005ftest;

  private volatile javax.el.ExpressionFactory _el_expressionfactory;
  private volatile org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public java.util.Set<java.lang.String> getPackageImports() {
    return _jspx_imports_packages;
  }

  public java.util.Set<java.lang.String> getClassImports() {
    return _jspx_imports_classes;
  }

  public javax.el.ExpressionFactory _jsp_getExpressionFactory() {
    if (_el_expressionfactory == null) {
      synchronized (this) {
        if (_el_expressionfactory == null) {
          _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
        }
      }
    }
    return _el_expressionfactory;
  }

  public org.apache.tomcat.InstanceManager _jsp_getInstanceManager() {
    if (_jsp_instancemanager == null) {
      synchronized (this) {
        if (_jsp_instancemanager == null) {
          _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
        }
      }
    }
    return _jsp_instancemanager;
  }

  public void _jspInit() {
    _005fjspx_005ftagPool_005fc_005fif_0026_005ftest = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
  }

  public void _jspDestroy() {
    _005fjspx_005ftagPool_005fc_005fif_0026_005ftest.release();
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
      throws java.io.IOException, javax.servlet.ServletException {

    if (!javax.servlet.DispatcherType.ERROR.equals(request.getDispatcherType())) {
      final java.lang.String _jspx_method = request.getMethod();
      if ("OPTIONS".equals(_jspx_method)) {
        response.setHeader("Allow","GET, HEAD, POST, OPTIONS");
        return;
      }
      if (!"GET".equals(_jspx_method) && !"POST".equals(_jspx_method) && !"HEAD".equals(_jspx_method)) {
        response.setHeader("Allow","GET, HEAD, POST, OPTIONS");
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "JSP들은 오직 GET, POST 또는 HEAD 메소드만을 허용합니다. Jasper는 OPTIONS 메소드 또한 허용합니다.");
        return;
      }
    }

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html; charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\r\n\r\n\r\n\r\n\r\n");
      out.write('\r');
      out.write('\n');
      out.write("\r\n\r\n\r\n\r\n\r\n");
      out.write("\r\n<link rel=\"stylesheet\" href=\"/resources/common/css/default.css?ver=20181127_01\" />\r\n");
      out.write('\r');
      out.write('\n');
      if (_jspx_meth_c_005fif_005f0(_jspx_page_context))
        return;
      out.write('\r');
      out.write('\n');
      if (_jspx_meth_c_005fif_005f1(_jspx_page_context))
        return;
      out.write("\r\n\r\n\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/common/js/jquery/jquery-3.1.1.min.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/common/js/jquery/jquery.color-2.1.2.min.js\"></script>  \r\n<script type=\"text/javascript\" src=\"/resources/common/js/jquery/jquery.serialize-object.min.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/common/js/jquery/autoNumeric.min.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/common/js/erp_common.js?ver=20181121.01\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/common/js/erp_popup.js?ver=20181121.01\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/common/js/jquery/pgpopup_2.0.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/common/js/contextMenu.js?ver=20190807.01\"></script>\r\n\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/common/js/erp_header.js?ver=20181129.01\"></script>\r\n");
      out.write('\r');
      out.write('\n');
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxCommon/codebase/dhtmlxcommon.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxCommon/codebase/dhtmlxcore.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxCommon/codebase/dhtmlxcontainer.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxCommon/codebase/dhtmlxdataprocessor.js\"></script>\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/dhtmlxgrid.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_filter.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_splt.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_srnd.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_json.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_selection.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_nxml.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_pgn.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_rowspan.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_keymap.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_math.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_mcol.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_group.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/ext/dhtmlxgrid_fast.js\"></script>\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_cntr.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_dhxcalendar.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_combo.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_popup.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_robp.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_ro_txt.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_record.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxGrid/codebase/excells/dhtmlxgrid_excell_sub_row.js\"></script>\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxCombo/codebase/dhtmlxcombo.js\"></script>\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxWindows/codebase/dhtmlxwindows.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxWindows/codebase/ext/dhtmlxwindows_resize.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxWindows/codebase/ext/dhtmlxwindows_menu.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxWindows/codebase/ext/dhtmlxwindows_dnd.js\"></script>\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxMessage/codebase/dhtmlxmessage.js\"></script>\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxCalendar/codebase/dhtmlxcalendar.js\"></script>\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTabbar/codebase/dhtmlxtabbar.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTabbar/codebase/dhtmlxtabbar_start.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTabbar/codebase/dhtmlxtabbar_deprecated.js\"></script>\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxLayout/codebase/dhtmlxlayout.js?ver=20181127_01\"></script>\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTree/codebase/dhtmlxtree.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTree/codebase/ext/dhtmlxtree_json.js\"></script>\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTreeView/codebase/dhtmlxtreeview.js\"></script>\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTreeGrid/codebase/dhtmlxtreegrid.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTreeGrid/codebase/ext/dhtmlxtreegrid_filter.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTreeGrid/codebase/ext/dhtmlxtreegrid_lines.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxTreeGrid/codebase/ext/dhtmlxtreegrid_property.js\"></script>\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxRibbon/codebase/dhtmlxribbon.js\"></script>\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxToolbar/codebase/dhtmlxtoolbar.js\"></script>\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxPopup/codebase/dhtmlxpopup.js\"></script>\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxVault_v241_pro/sources/dhtmlxVault/codebase/dhtmlxvault.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxVault_v241_pro/sources/dhtmlxVault/codebase/ext/dhtmlxvault_dnd.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxVault_v241_pro/sources/dhtmlxVault/codebase/ext/dhtmlxvault_progress.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxVault_v241_pro/sources/dhtmlxVault/codebase/ext/dhtmlxvault_records.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxVault_v241_pro/sources/dhtmlxVault/codebase/swfobject.js\"></script>\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxForm/codebase/dhtmlxform.js\"></script>\r\n");
      out.write("\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxMenu/codebase/dhtmlxmenu.js\"></script>\r\n<script type=\"text/javascript\" src=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxMenu/codebase/ext/dhtmlxmenu_ext.js\"></script>\r\n");
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try {
            if (response.isCommitted()) {
              out.flush();
            } else {
              out.clearBuffer();
            }
          } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }

  private boolean _jspx_meth_c_005fif_005f0(javax.servlet.jsp.PageContext _jspx_page_context)
          throws java.lang.Throwable {
    javax.servlet.jsp.PageContext pageContext = _jspx_page_context;
    javax.servlet.jsp.JspWriter out = _jspx_page_context.getOut();
    //  c:if
    org.apache.taglibs.standard.tag.rt.core.IfTag _jspx_th_c_005fif_005f0 = (org.apache.taglibs.standard.tag.rt.core.IfTag) _005fjspx_005ftagPool_005fc_005fif_0026_005ftest.get(org.apache.taglibs.standard.tag.rt.core.IfTag.class);
    boolean _jspx_th_c_005fif_005f0_reused = false;
    try {
      _jspx_th_c_005fif_005f0.setPageContext(_jspx_page_context);
      _jspx_th_c_005fif_005f0.setParent(null);
      // /WEB-INF/jsp/common/include/default_resources_header.jsp(5,0) name = test type = boolean reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_c_005fif_005f0.setTest(((java.lang.Boolean) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${empSessionDto == null }", boolean.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null)).booleanValue());
      int _jspx_eval_c_005fif_005f0 = _jspx_th_c_005fif_005f0.doStartTag();
      if (_jspx_eval_c_005fif_005f0 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
        do {
          out.write("\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/common.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxgrid_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxcombo_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxmessage_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxcalendar_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxtabbar_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxlayout_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxtree_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxtreeview_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxribbon_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxwindows_dhx_skyblue.css\" />\r\n");
          out.write("<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxtoolbar_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxpopup_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxvault_dhx_skyblue.css\"/>  \r\n<link rel=\"stylesheet\" href=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxForm/codebase/skins/dhtmlxform_dhx_skyblue.css\"/>  \r\n<link rel=\"stylesheet\" href=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxMenu/codebase/skins/dhtmlxmenu_dhx_skyblue.css\"/>  \r\n\r\n");
          int evalDoAfterBody = _jspx_th_c_005fif_005f0.doAfterBody();
          if (evalDoAfterBody != javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN)
            break;
        } while (true);
      }
      if (_jspx_th_c_005fif_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
      _005fjspx_005ftagPool_005fc_005fif_0026_005ftest.reuse(_jspx_th_c_005fif_005f0);
      _jspx_th_c_005fif_005f0_reused = true;
    } finally {
      org.apache.jasper.runtime.JspRuntimeLibrary.releaseTag(_jspx_th_c_005fif_005f0, _jsp_getInstanceManager(), _jspx_th_c_005fif_005f0_reused);
    }
    return false;
  }

  private boolean _jspx_meth_c_005fif_005f1(javax.servlet.jsp.PageContext _jspx_page_context)
          throws java.lang.Throwable {
    javax.servlet.jsp.PageContext pageContext = _jspx_page_context;
    javax.servlet.jsp.JspWriter out = _jspx_page_context.getOut();
    //  c:if
    org.apache.taglibs.standard.tag.rt.core.IfTag _jspx_th_c_005fif_005f1 = (org.apache.taglibs.standard.tag.rt.core.IfTag) _005fjspx_005ftagPool_005fc_005fif_0026_005ftest.get(org.apache.taglibs.standard.tag.rt.core.IfTag.class);
    boolean _jspx_th_c_005fif_005f1_reused = false;
    try {
      _jspx_th_c_005fif_005f1.setPageContext(_jspx_page_context);
      _jspx_th_c_005fif_005f1.setParent(null);
      // /WEB-INF/jsp/common/include/default_resources_header.jsp(24,0) name = test type = boolean reqTime = true required = true fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_c_005fif_005f1.setTest(((java.lang.Boolean) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${empSessionDto != null}", boolean.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null)).booleanValue());
      int _jspx_eval_c_005fif_005f1 = _jspx_th_c_005fif_005f1.doStartTag();
      if (_jspx_eval_c_005fif_005f1 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
        do {
          out.write("\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/common.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxgrid_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxcombo_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxmessage_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxcalendar_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxtabbar_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxlayout_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxtree_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxtreeview_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxribbon_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxwindows_dhx_skyblue.css\" />\r\n");
          out.write("<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxtoolbar_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxpopup_dhx_skyblue.css\" />\r\n<link rel=\"stylesheet\" href=\"/resources/framework/theme/default/dhtmlxvault_dhx_skyblue.css\"/>\r\n<link rel=\"stylesheet\" href=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxForm/codebase/skins/dhtmlxform_dhx_skyblue.css\"/>  \r\n<link rel=\"stylesheet\" href=\"/resources/framework/dhtmlxSuite_v508_pro/sources/dhtmlxMenu/codebase/skins/dhtmlxmenu_dhx_skyblue.css\"/>  \r\n");
          int evalDoAfterBody = _jspx_th_c_005fif_005f1.doAfterBody();
          if (evalDoAfterBody != javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN)
            break;
        } while (true);
      }
      if (_jspx_th_c_005fif_005f1.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
      _005fjspx_005ftagPool_005fc_005fif_0026_005ftest.reuse(_jspx_th_c_005fif_005f1);
      _jspx_th_c_005fif_005f1_reused = true;
    } finally {
      org.apache.jasper.runtime.JspRuntimeLibrary.releaseTag(_jspx_th_c_005fif_005f1, _jsp_getInstanceManager(), _jspx_th_c_005fif_005f1_reused);
    }
    return false;
  }
}