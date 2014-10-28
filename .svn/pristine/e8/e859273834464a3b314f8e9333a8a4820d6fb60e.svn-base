<%@ page language="java" trimDirectiveWhitespaces="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%-- <%@ taglib prefix="onepay" uri="http://1pay.vn/jsp/jstl/functions"%> --%>
<%@ page import="vn.onepay.common.SharedConstants, vn.onepay.account.model.Account, java.lang.String"%>
<%
	Account account = (Account) request.getSession().getAttribute(SharedConstants.ACCOUNT_LOGINED);

	boolean is_staff = false;
	if(account != null) {
		is_staff = account.isStaff();
		request.setAttribute("is_staff", is_staff);
		
		boolean isAdmin = account.isAdmin();
		boolean mbiz =  SharedConstants.MBIZ && isAdmin;
		request.setAttribute("MBIZ", mbiz);
	}
%>
<div class="left_cat">
	<ul class="sub_cat">
		<li><a href="<%=request.getContextPath() %>/protected/dashboard.html" class="cat_head">Trang chủ</a></li>
		
		<li><a href="#" class="user_normal">Cá nhân</a>
			<ul>
				<li><a href="#">Hoạt động </a></li>
				<li><a href="<%=request.getContextPath()%>/protected/profile.html" class="${accountProfile?'slc_link':''}">Thông tin cá nhân </a></li>
				<li><a href="<%=request.getContextPath()%>/protected/message.html" class="${accountMesage?'slc_link':''}">Tin nhắn <span class="cat_no"><c:out value="${accountMesageCount}" /></span></a></li>
				<li><a href="<%=request.getContextPath()%>/protected/alert.html" class="${accountAlert?'slc_link':''}">Thông báo <span class="cat_no"><c:out value="${accountAlertCount}" /></span></a></li>
				<li><a href="<%=request.getContextPath()%>/protected/api.html" class="${accountApi?'slc_link':''}">Developer APIs </a></li>
				<!-- 
				<li><a href="<%=request.getContextPath()%>/protected/card-sand-box.html" class="${sandBox?'slc_link':''}">1Pay Sandbox </a></li>
				 -->
				
			</ul>
		</li>
	</ul>
	<%-- <c:if test="${!MBIZ}">
	<ul class="sub_cat">
		<li><a href="#" class="qtr_svr">Quản trị & vận hành</a>
			<ul>
				<li><a href="<%=request.getContextPath()%>/console/index.wss" class="${accountConsole?'slc_link':''}">Quản trị sản phẩm</a></li>
				<li><a href="<%=request.getContextPath() %>/protected/comparison.html" class="${comparisonNavMenu?'slc_link':''}">Đối soát & thanh toán </a></li>
				<%if(account.isOperator() || account.isBookKeeper() || account.isBilling()){ %>
				<li><a href="<%=request.getContextPath() %>/protected/provider_comparison.html" class="${providerComparisonNavMenu?'slc_link':''}">Đối soát Provider </a></li>
				<%} %>				
				<li><a href="<%=request.getContextPath() %>/protected/merchant_contract_manager.html" class="${constractNavMenu?'slc_link':''}">Hợp đồng điện tử</a></li>
				<%if(account.isStaff()){ %>
					<li><a href="<%=request.getContextPath() %>/protected/merchant_profile_manager.html" class="${merchantProfileNavMenu?'slc_link':''}">Quản lý Profile</a></li>
				<%} else{%>
					 <li><a href="<%=request.getContextPath() %>/protected/merchant_profile_manager.html" class="${merchantProfileNavMenu?'slc_link':''}">Thông tin Profile</a></li>
				<%} %>	
				
				<%if(account.isOperator() || account.isBizSupporter()){ %>
					<li><a href="<%=request.getContextPath() %>/console/sms-command-code-manager.wss" class="${smsCmdNavMenu?'slc_link':''}">Quản lý mã SMS</a></li>
				<%}%>
				
				<%if(account.isOperator() || account.isBizSupporter() || account.isCustomerCare()){ %>
					<li><a href="<%=request.getContextPath() %>/protected/merchant-refund.html" class="${mcRefundNavMenu?'slc_link':''}">Hỗ trợ CSKH</a></li>
				<%}%>
				
				<%if(account.checkRole(Account.ACCOUNT_STAFF_ROLE) && account.checkRoles(new String[]{Account.ACCOUNT_ADMIN_ROLE, Account.ACCOUNT_OPERATION_MANAGER_ROLE, Account.ACCOUNT_MARKETING_MANAGER_ROLE, Account.ACCOUNT_MERCHANT_MANAGER_ROLE})){%>
					<li><a href="<%=request.getContextPath() %>/protected/manage-email-marketing.html" class="${emailMarketingMenu?'slc_link':''}">Email Marketing</a></li>
				<%}%>
			</ul>
		</li>
	</ul>
	</c:if>
	<ul class="sub_cat">
		<li>
			<a href="<%=request.getContextPath()%>${((account_logined != null && is_staff) || (account_activated_chargings !=null)) ?'/protected/dashboard.html':'/dich-vu.html'}" 
				class="cat_head">
				Dịch vụ của tôi
			</a>
			<ul>
				<c:forEach var="chargingService" items="${ALL_ACTIVED_CHARGING_SERVICES}">
				<c:set var="chargingServiceLower" value="${fn:toLowerCase(chargingService)}" />
				<li>
					<c:choose>
						<c:when test="${(account_logined != null && is_staff)||(account_activated_chargings!=null && account_activated_chargings[chargingService])}">
							<a href="<%=request.getContextPath()%>/protected/dashboard.html?chargingService=${chargingService}" 
								class="${chargingServiceLower}_${(param.chargingService!=null && fn:length(param.chargingService) >0 && param.chargingService==chargingService)?'active':'normal'}">
								${onepay:chargingServiceCode2Text(chargingService)}
							</a>
						</c:when>
						<c:otherwise>
							<a class="${chargingServiceLower}_invi" data-reveal-id="${chargingServiceLower}Modal" data-dismissmodalclass="modal_close">
								${onepay:chargingServiceCode2Text(chargingService)}
							</a>
							<div id="${chargingServiceLower}Modal" class="reveal-modal">
								<div class="srv_row">
									<a href="<%=request.getContextPath() %>/dich-vu.html?n=${chargingServiceLower}">
										Vui lòng ký hợp đồng điện tử ${onepay:chargingServiceCode2Text(chargingService)} tại đây để truy cập mục này!
									</a>
								</div>
								<div>
									<input type="button" name="cancel" value="Đóng" class="btn_greensmall modal_close" />
								</div>
							</div>
						</c:otherwise>
					</c:choose>
				</li>
				</c:forEach>
				<li><a class="sub_invi">Sub Charging</a></li>
				<li><a class="direct_invi">Direct Charging</a></li>
				<li><a href="<%=request.getContextPath() %>/dich-vu.html" class="more_normal">Kích hoạt dịch vụ...</a></li>
			</ul>
		</li>
	</ul>
	<ul class="sub_cat">
		<li><a href="#" class="tool_normal">Công cụ</a>
			<ul>
				<li><a href="<%=request.getContextPath()%>/merchant-support.html" class="${merchantSupport?'slc_link':''}">Hỗ trợ kết nối</a></li>
				<li><a href="<%=request.getContextPath()%>/protected/tra-cuu.html" class="${cardReport?'slc_link':''}">Tra cứu</a></li>
				<li><a href="<%=request.getContextPath()%>/protected/dashboard.html" class="${cardSummary?'slc_link':''}">Thống kê</a></li>
				<!-- 
				<li><a href="#" class="${cardChartByDay?'slc_link':''}">Biểu đồ doanh thu</a></li>
				 -->
				<li><a href="<%=request.getContextPath() %>/protected/card-analytics.html" class="${cardChartByHour?'slc_link':''}">Phân tích thông minh</a></li>
			</ul>
		</li>
	</ul>

	<ul class="sub_cat">
		<li><a href="#" class="money_normal">Ví tiền</a>
			<ul>
				<li><a href="<%=request.getContextPath()%>/protected/wallet.html" class="${wallet?'slc_link':''}">Số dư tài khoản</a></li>
				<li><a href="#">Rút tiền</a></li>
				<li><a href="#">Hạn mức thanh toán</a></li>
				<li><a href="<%=request.getContextPath()%>/protected/billing_info.html" class="${billingInfo?'slc_link':''}">Cấu hình thanh toán</a></li>
			</ul></li>
	</ul>
	<ul class="sub_cat">
		<li><a href="#" class="help_normal">Help center</a>
			<ul>
				<li><a href="<%=request.getContextPath() %>/lien-he.html">Liên hệ nhanh</a></li>
				<li><a href="http://help.1pay.vn">Trung tâm hỗ trợ</a></li>
			</ul></li>
	</ul> --%>
</div>