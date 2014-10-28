<%@ page language="java" trimDirectiveWhitespaces="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="vn.onepay.common.SharedConstants, vn.onepay.account.model.Account, java.lang.String"%>
<!-- Header -->
<div id="w_header">
	<a href="<%=request.getContextPath()%>/trang-chu.html" class="logo_1pay"></a>

	<div id="nav">
		<ul id="qm0" class="qmmc">
			<li><a class="qmparent nav_menu${menuTrangChu?'_slc':''}" href="<%=request.getContextPath()%>/trang-chu.html">Trang chủ</a></li>

			<li><a class="qmparent nav_menu${menuDichVu?'_slc':''}" href="<%=request.getContextPath()%>/dich-vu.html">Dịch vụ</a>
				<ul>
					<li><a href="<%=request.getContextPath()%>/dich-vu.html?n=sms">SMS Charging</a></li>
					<li><a href="<%=request.getContextPath()%>/dich-vu.html?n=card">Card Charging</a></li>
					<li><a href="<%=request.getContextPath()%>/dich-vu.html?n=wap">Wap Charging</a></li>
					<li><a href="<%=request.getContextPath()%>/dich-vu.html?n=iac">SMSplus Charging</a></li>
					<li><a href="<%=request.getContextPath()%>/dich-vu.html?n=bank">Bank Charging</a></li>
					<li><a href="<%=request.getContextPath()%>/dich-vu.html">Direct Charging</a></li>
					<li><a href="<%=request.getContextPath()%>/dich-vu.html">Sub Charging</a></li>
					
				</ul>
			</li>
			<li><a class="qmparent nav_menu${menuNhaPhatTrien?'_slc':''}" href="http://dev.1pay.vn">Nhà phát triển</a>
				<%-- <ul>
					<li><a href="<%=request.getContextPath()%>/nha-phat-trien.html">Công cụ</a></li>
					<li><a href="http://dev.1pay.vn">Tài liệu APIs</a></li>
					<li><a href="<%=request.getContextPath()%>/nha-phat-trien/huong-dan.html">Hướng dẫn</a></li>
					<li><a href="<%=request.getContextPath()%>/merchant-support.html">Tiện ích hỗ trợ </a></li>
				</ul> --%>
			</li>


			<li><a class="qmparent nav_menu${menuCongDong?'_slc':''}" href="http://forum.1pay.vn">Cộng đồng</a>
				<ul>
					<li><a href="http://forum.1pay.vn">Diễn đàn </a></li>
					<li><a href="http://facebook.com/1pay.vn">Facebook</a></li>
					<li><a href="#">Twitter</a></li>
					<li><a href="#">Google+</a></li>
				</ul>
			</li>

			<li><a href="<%= request.getContextPath() %>/news/category.html" class="qmparent nav_menu${menuTinTuc?'_slc':''}">Tin tức</a>
				<ul>
					<li><a href="<%= request.getContextPath() %>/news/category.html">Tin hoạt động</a></li>
					<li><a href="<%= request.getContextPath() %>/news/category.html">Sự kiện</a></li>
					<li><a href="<%= request.getContextPath() %>/news/category.html">Bản tin ngành nội dung số</a></li>
				</ul>
			</li>

			<li><a class="qmparent nav_menu${menuHoTro?'_slc':''}" href="<%=request.getContextPath() %>/lien-he.html">Hỗ trợ</a>
				<ul>
					<li><a href="http://help.1pay.vn">Help center</a></li>
					<li><a href="<%=request.getContextPath() %>/dieu-khoan.html">Điều khoản sử dụng</a></li>
					<li><a href="<%=request.getContextPath() %>/chinh-sach-thanh-toan.html">Chính sách thanh toán</a></li>
					<li><a href="<%=request.getContextPath() %>/ban-quyen.html">Bản quyền</a></li>
					<li><a href="<%=request.getContextPath() %>/lien-he.html">Liên hệ</a></li>
				</ul>
			</li>
			<li class="qmclear">&nbsp;</li>
		</ul>
		<!-- Create Menu Settings: (Menu ID, Is Vertical, Show Timer, Hide Timer, On Click ('all' or 'lev2'), Right to Left, Horizontal Subs, Flush Left, Flush Top) -->
		<script type="text/javascript">
			qm_create(0, false, 0, 250, false, false, false, false, false);
		</script>
		<!--[if IE]><iframe onload="on_script_loaded(function() { HashKeeper.reloading=false; });" style="display: none" name="hashkeeper" src="/blank" height="1" width="1" id="hashkeeper"></iframe><![endif]-->
	</div>
	<div id="account-header">
		<ul class="nav">
			<c:choose>
			<c:when test="${account_logined != null}">
				<li class="ui-button">
					<a href="#" class="header-nav-link" onclick="return false;">
						<span id="emsnippet-100eb3184c1c497f"><c:out value="${account_logined.username}" /></span>
						<span class="lbl_gray">L${account_logined_level}</span>
					</a>
					<div class="sub-nav chat-bubble" align="left">
						<ul>
							<li>
								<a href="<%= request.getContextPath()%>/protected/profile.html">
									<div class="ava_box">
										<img src="<%= request.getContextPath()%>/images/avatar.png" border="0" />
									</div>
									<div>
										<strong>${account_logined.username}</strong><br/>
										<img alt="level" src="<%=request.getContextPath()%>/images/level_chart.png"><span style="color:#2C8F39;"><strong>Level:</strong> ${account_logined_level}<br/>
										<img alt="exp" src="<%=request.getContextPath()%>/images/exp_point.png"><strong>Exp:</strong> ${account_logined_exp}</span>
									</div>
								</a>
							</li>
							<div class="clear"></div>
							<%
							Account account = (Account) request.getSession().getAttribute(SharedConstants.ACCOUNT_LOGINED);
							%>
							<%if(account.isAdmin() || account.isOperator() || account.isShareHolder() || account.isReporter() || account.isBizManager() || account.isBizStaff() || account.isBilling()){%>
							<li><a href="<%= request.getContextPath()%>/protected/revenue-dashboard.html">Báo cáo LNG</a></li>
							<%} %>
							<%if(!SharedConstants.MBIZ && (account.isAdmin() || account.isOperator() || account.isBizManager())){%>
							<li><a href="<%= request.getContextPath()%>/protected/kpi_chart.html">Theo dõi kế hoạch</a></li>
							<%} %>
							<%if(!SharedConstants.MBIZ && (account.isAdmin() || account.isOperator() || account.isBizSupportManager())){%>
							<li><a href="<%= request.getContextPath()%>/cdr/sms-cdr-filter.cdr">Thử nghiệm nội bộ</a></li>
							<%} %>
							
							<%
							if(!SharedConstants.MBIZ && account.checkRole(Account.ACCOUNT_STAFF_ROLE) && account.checkRoles(new String[]{Account.ACCOUNT_ADMIN_ROLE, Account.ACCOUNT_OPERATION_MANAGER_ROLE})){
							%>
							<li><a href="<%= request.getContextPath()%>/protected/cash-flow.html">Quản lý dòng tiền</a></li>
							<%} %>
							<%
							if(!SharedConstants.MBIZ && account.checkRole(Account.ACCOUNT_STAFF_ROLE) && account.checkRoles(new String[]{Account.ACCOUNT_ADMIN_ROLE, Account.ACCOUNT_OPERATION_MANAGER_ROLE, Account.ACCOUNT_SHARE_HOLDER_ROLE, Account.ACCOUNT_MERCHANT_MANAGER_ROLE, Account.ACCOUNT_BIZ_SUPPORTER_ROLE,  Account.ACCOUNT_CUSTOMER_CARE_ROLE})){
							%>
							<li><a href="<%= request.getContextPath()%>/protected/merchant-manager.html">Quản lý Merchant</a></li>
							<%} %>
							<%if(!SharedConstants.MBIZ && account.checkRole(Account.ACCOUNT_STAFF_ROLE) && account.checkRoles(new String[]{Account.ACCOUNT_OPERATION_MANAGER_ROLE, Account.ACCOUNT_MERCHANT_MANAGER_ROLE, Account.ACCOUNT_BIZ_SUPPORTER_ROLE})){ %>
							<li><a href="<%= request.getContextPath()%>/protected/merchant_profile_manager.html">Quản lý Merchant Profiles</a></li>
							<%} %>
							
							<%
							if(!SharedConstants.MBIZ && account.checkRole(Account.ACCOUNT_STAFF_ROLE) && account.checkRoles(new String[]{Account.ACCOUNT_OPERATION_MANAGER_ROLE, Account.ACCOUNT_BIZ_SUPPORTER_ROLE})){
							%>
								<li><a href="<%= request.getContextPath()%>/protected/provider_profile_manager.html">Quản lý Provider's Profile</a></li>
							<%}%>
							<%
								if(account.checkRole(Account.ACCOUNT_STAFF_ROLE) && account.checkRoles(new String[]{Account.ACCOUNT_ADMIN_ROLE, Account.ACCOUNT_OPERATION_MANAGER_ROLE})){
							%>
							<li><a href="<%= request.getContextPath()%>/protected/email-announcement.html">Thông báo Email</a></li>
							<%} %>
							<%	if(account.checkRole(Account.ACCOUNT_STAFF_ROLE) && account.checkRoles(new String[]{Account.ACCOUNT_ADMIN_ROLE, Account.ACCOUNT_OPERATION_MANAGER_ROLE, Account.ACCOUNT_MARKETING_MANAGER_ROLE, Account.ACCOUNT_MERCHANT_MANAGER_ROLE})){%>
								<li><a href="<%= request.getContextPath()%>/protected/manage-email-marketing.html">Email Marketing</a></li>
							<%} %>
							<li><a href="<%= request.getContextPath()%>/protected/profile.html">Cấu hình</a></li>
							<li><a href="<%= request.getContextPath()%>/logout.html">Sign out</a></li>
						</ul>
						<div class="chat-bubble-arrow-border"></div>
						<div class="chat-bubble-arrow"></div>
					</div>
				</li>
				
			<%-- <li class="ui-button">
				<a class="header-nav-link" href="<%= request.getContextPath()%>/protected/dashboard.html">
					<span id="emsnippet-100eb3184c1c497f"><c:out value="${_const_cas_assertion_.principal.name}" /></span>
				</a>
			</li> --%>
			</c:when>
			<c:otherwise>
			<li>
				<div class="down" id="top-login-wrapper" style="padding-top:10px;">
				<a href="<%= request.getContextPath()%>/login.html"><img src="<%=request.getContextPath()%>/images/door-open-in.png"
						border="0" align="absmiddle" hspace="5" /> Đăng nhập</a>
				</div>
			</li>
			</c:otherwise>
			</c:choose>
			<script type="text/javascript">
				$(document).ready(function() {
					$('.ui-button').live('click', function() {
						var newClass= $(this).attr('class') + '';
						if(newClass.indexOf(' active') > 0) {
							newClass = newClass.replace(/ active/gi,'');
						} else {
							newClass = newClass.replace(/ active/gi,'') + ' active';
						}
						$(this).attr('class',newClass);
					});
				});
			</script>
		</ul>
	</div>
	<div class="clear"></div>
</div>

<%
	request.setAttribute("ALL_ACTIVED_CHARGING_SERVICES", SharedConstants.ALL_ACTIVED_CHARGING_SERVICES);
%>
<!-- / Header -->