<%@ page language="java" trimDirectiveWhitespaces="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net/el"%>
<%@ page import="vn.onepay.common.SharedConstants, vn.onepay.account.model.Account, java.lang.String"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:include page="head.jsp"></jsp:include>
<link href="${pageContext.request.contextPath }/css/personal.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/css/jquery.multiselect.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/jquery-ui.min.css" />
<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.multiselect.js"></script>

<!-- count down -->
<%-- <link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/css/jquery.countdownTimer.css" /> --%>
<!-- <script type="text/javascript" src="jquery-2.0.3.js"></script> -->
<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.countdownTimer.js"></script>

<script src="<%=request.getContextPath()%>/js/numeral.js" type="text/javascript"></script>

<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/css/jquery.datetimepicker.css"/>
<script src="<%=request.getContextPath() %>/js/jquery.datetimepicker.js"></script>

<jsp:include page="chart.lib.jsp" />

<style>
	.fieldset_filter {border: solid 1px #ccc;margin-left:20px; margin-bottom:20px; width: auto;}
</style>

<script type="text/javascript">
/* var th = new Date();
alert(th.toString('dd/MM/yyyy')); */

$(function(){
	
	$("#filter_merchant").multiselect({
		selectedList: 4,
		noneSelectedText: "Tất cả"
	});
	$("#filter_provider").multiselect({
		selectedList: 4,
		noneSelectedText: "Tất cả"
	});
	$("#filter_card_type").multiselect({
		selectedList: 4,
		noneSelectedText: "Tất cả"
	});
	$("#filter_card_amount").multiselect({
		selectedList: 4,
		noneSelectedText: "Tất cả"
	});
});
</script>

<style >
	.search_ , .search_:HOVER{
		background: url("<%=request.getContextPath()%>/images/btngreen_bg.png") repeat-x scroll center top;
		color: #FFFFFF;
		display: block;
		float: right;
		font-weight: bold;
		height: 20px;
		line-height: 20px;
		padding-left: 5px;
		padding-right: 5px;
		border: 1px solid #39B54A;
		border-radius: 10px;
		text-shadow: 0 1px #20942B;
	}
	
	.box_locketqua table a{
		font-size: 14px;
		color: #2c8f39;
		padding-top: 2px;
		
	}
	
	.box_locketqua table a.slc_link {
		color: #FFA200;
	}
	
	.select_filter{
		border: 1px solid #CCCCCC;
		padding: 6px;
		margin: 0px;
		-webkit-border-radius: 3px;
		-moz-border-radius: 3px;
		border-radius: 3px;
		width: 115px;
		margin-left: 0px;
		box-shadow: 0 0 0 #000000, 0 3px 3px #EEEEEE inset;
	}
	.text_filter{
		border: 1px solid #CCCCCC;
		padding: 6px;
		margin: 0px;
		-webkit-border-radius: 3px;
		-moz-border-radius: 3px;
		border-radius: 3px;
		width: 235px;
		margin-left: 0px;
		box-shadow: 0 0 0 #000000, 0 3px 3px #EEEEEE inset;
	}
	.chart , .chart:HOVER{
		background: url("<%=request.getContextPath()%>/images/btngreen_bg.png") repeat-x scroll center top;
		color: #FFFFFF;
		display: block;
		float: right;
		font-weight: bold;
		height: 20px;
		line-height: 20px;
		padding-left: 5px;
		padding-right: 5px;
		border: 1px solid #39B54A;
		border-radius: 10px;
		text-shadow: 0 1px #20942B;
	}
	
	.label_filter{
		margin-left: 20px;
		width: 80px;
		display: inline-block;
	}
	
	.pie{
		margin:auto; display:table; 
	}
	.pie_child{
		
		width: 500px;
	}
	.pie_child_inline{
		/* width: 200px; */
	}
	
	#countdowntimer{
		display: none;
		
	}
</style>
</head>
<%
	Account account = (Account) request.getSession().getAttribute(SharedConstants.ACCOUNT_LOGINED);
	boolean isAdmin = account.isAdmin();
	boolean mbiz =  SharedConstants.MBIZ && isAdmin;
	request.setAttribute("MBIZ", mbiz);
	
	request.setAttribute("isOperator", account.isOperator());
	request.setAttribute("isBizSupporter", account.isBizSupporter());
	request.setAttribute("isCustomerCare", account.isCustomerCare());
	
%>
<body>
	<!-- 1PAY WEB -->
	<div id="wrapper">
		<!-- Web Top -->
		<div id="w_top">
			<div class="layout_1000">
				<!-- Header -->
				<%request.setAttribute("menuTrangChu", true); %>
				<jsp:include page="header.jsp"></jsp:include>
				<!-- / Header -->

				<!-- Body -->
				<div id="w_body">
					<div class="row_sub">
						<!-- Persanal Bar -->
						<jsp:include page="include_personal_bar.jsp" />
						<!-- Left Menu -->
						<%request.setAttribute("cardReportElastic", true);%>
						<jsp:include page="card-charging-chart-menu.jsp" />
						
						<div class="right_content">
							<%-- <a href="<%=request.getContextPath() %>/protected/card-charging.html" class="search_" style="margin-right: 5px;"><span>Tìm kiếm chi tiết</span></a> --%>
							<h1 class="srv_title">Phân tích giao dịch thẻ</h1>
							<div id="countdowntimer">
								<i>
									(refresh sau
									<span id="future_date"></span>
									giây)
								</i>
							</div>
							<script type="text/javascript">
							$(function(){
								//function refresh(){
									var refresh = '<c:out value="${param.refresh}"/>';
									if(refresh == '' || refresh != 'on')
										return;
									var timeText = '<c:out value="${param.from_date}"/>';
									var day = new Date();
									var today = new Date(day.getFullYear() +'/' + (day.getMonth() +1) + '/' +day.getDate());
									
									var timeSearch;
									if(timeText != '')
										timeSearch = Date.parseExact(timeText, 'dd/MM/yyyy HH:mm');
									else
										timeSearch = today;
									
									if(timeSearch.getTime() >= today.getTime() && timeSearch.getTime() < (today.getTime() + 24*60*60*1000) ){
										$('#countdowntimer').css('display', 'block');
										$(function(){
					                         $('#future_date').countdowntimer({
					                             minutes :1,
					                             size : "lg",
					                             timeUp : timeisUp
					                         });
					                   });
										function timeisUp() {
											location.reload();
								        }
									}
								//}
							});
							</script>
							
							<!-- Filter -->
							<div id="filter_locketqua">
								<h3 class="filter_label open">
									<a href="#">Lọc kết quả</a>
								</h3>
							</div>
							<form action="card-analytics.html" method="get" name="filter_histogram">
							<div class="box_locketqua">
								
									<c:forEach items="${model.fieldMaps }" var="map">
									
										<c:if test="${param[map.key] != null && param[map.key] != ''  }">
											<input type="hidden" name="${map.key }" value="${param[map.key] }"/>
										</c:if>
									</c:forEach>	
									
									<div class="filter_row">
										<label class="label_filter">Từ ngày:</label>
										<input id="from_date" maxlength="100" name="from_date" value="${param.from_date}" class="select_filter" placeholder="Chọn ngày"/>
										<label class="label_filter">Đến ngày:</label>
										<input id="to_date" maxlength="100" name="to_date" value="${param.to_date}" class="select_filter" placeholder="Chọn ngày"/>
										<label class="label_filter">Trạng thái:</label>
										<select class="select_filter" name="filter_status" style="width:145px; padding: 6px; margin-left: 0px;">
												<option value="" ${param.filter_status == ''?'selected':''}>Tất cả</option>
												<c:forEach var="status" items="${model.statusMap }">
														<option value="${status.key }" ${param.filter_status == status.key ?'selected':''}>
															<c:out value="${status.value}"/>
														</option>
												</c:forEach>
										</select>
										<script type="text/javascript">
										
											//$(document).ready(function(){
												//click provider
											$(function(){
													
												/* $('form[name=filter_histogram] select[name=filter_provider]').change(function(){
														$('form[name=filter_histogram]').submit();
												}); */
												//Enter
												$('form[name=filter_histogram] input[name=filter_merchant]').keydown(function(event) {
											        if (event.keyCode == 13) {
											            this.form.submit();
											            return false;
											         }
											    });
												var from_date = $('input[name=from_date]');
												if(from_date.val() == '')
												{
													var date = new Date();
													from_date.val(date.toString('dd/MM/yyyy') + ' 00:00');
												}
												
												var to_date = $('input[name=to_date]');
												if(to_date.val() == '')
												{
													var date = new Date();
													to_date.val(date.toString('dd/MM/yyyy') + ' 23:00');
													
												}
											
											});
											$('#from_date').datetimepicker({
												 lang:'vi',
												 timepicker:true,
												 format:'d/m/Y H:i'
												 /* ,
												 onClose : function(t){
													 $('form[name=filter_histogram]').submit();
												 } */
												});
											$('#to_date').datetimepicker({
												 lang:'vi',
												 timepicker:true,
												 format:'d/m/Y H:i'
												 /* ,
												 onClose : function(t){
													 $('form[name=filter_histogram]').submit();
												 } */
												});
											
												
										</script>
									</div>
									<div class="filter_row">
										<c:if test="${model.displayMerchant }">
											<label class="label_filter">Merchant:</label>
											<input type="text" name="filter_merchant" class="text_filter" placeholder="Nhập tên merchant" value="${param.filter_merchant }"/>
										</c:if>
										<c:if test="${isOperator ||  isBizSupporter || isCustomerCare}">
											<label class="label_filter">Nhà cung cấp:</label>
											<select class="select_filter" name="filter_provider" style="width:250px; padding: 6px; margin-left: 10px;">
													<option value="" ${param.filter_provider == ''?'selected':''}>Tất cả</option>
													<c:forEach var="provider" items="${model.facetAllsMap['paymentProvider'] }">
															<option value="${provider.getTerm() }" ${param.filter_provider == provider.getTerm()?'selected':''}>
																<c:out value="${provider.getTerm()}"/>
															</option>
													</c:forEach>
											</select>
										</c:if>
									</div>
									
									<%-- <div class="filter_row">
										<fieldset class="fieldset_filter">
											<legend>
												<input type="checkbox" name="telcoAll" value="telcoAll" id="telcoAll" class="chck_filter" ${fn:contains(param.telcoAll,'telcoAll')?'checked="checked"':'' }  /> Loại thẻ
												<script type="text/javascript">
													$(document).ready(function(){
														$('#telcoAll').click(function() {
															if(this.checked) {
																$(this).closest('.filter_row').find('input[type=checkbox]').attr('checked', 'checked');
															} else {
																$(this).closest('.filter_row').find('input[type=checkbox]').removeAttr('checked');
															}
														});
													});
												</script>
											</legend>
											
											<div style="padding: 2px;">
												<c:set var="allTc" value="," />
												<c:forEach var="tc" items="${paramValues.filter_card_type}">
													<c:set var="allTc" value="${allTc}${tc}," />
												</c:forEach>
												<c:forEach var="tc" items="${model.facetAllsMap['type']}">
													<div style="display: inline-block;">
														<c:set var="_tc" value=",${tc.getTerm()}," />
														<input type="checkbox" class="chck_filter" name="filter_card_type" title="${tc.getTerm()}" value="${tc.getTerm()}" 
															${fn:contains(allTc,_tc)?'checked="checked"':'' } />
														<label class="lbl_chcksub">${tc.getTerm()}</label>
													</div>
												</c:forEach>
											</div>
										</fieldset>
									</div> --%>
									
								<!-- <div class="filter_row">
									
								</div> -->
								
								<div class="filter_row" style="text-align: center;">
					               	<input  style="margin-top: 0px;"  class="btn_greensmall" type="submit" value="Lọc" />
				                </div>
							</div>
							
							<span style="display: block; float: right; margin-top: 10px">
								<input type="checkbox" id="comparation" name="comparation" ${param.comparation == 'on'?'checked':'' }/>
								<label>So sánh</label>
							</span>
							<span style="display: block; float: right; margin-top: 10px">
								<input type="checkbox" id="refresh" name="refresh" ${param.refresh == 'on'?'checked':'' }/>
								<label>refresh&nbsp</label>
							</span>
							<script type="text/javascript">
								$(document).ready(function(){
									$('#refresh').live('click', function(){
										var val = $(this).is(':checked');
										$(this).prop('checked', val);
										$('form[name=filter_histogram]').submit();
									});	
								});
							</script>
							</form>
							<c:choose>
								<c:when test="${model.total > 0}">
									<span class="pagebanner"> Tổng cộng có ${model.total} kết quả tìm thấy. 
										&nbsp(Thời gian tìm kiếm ${model.timeHandleTotal /1000.0} giây)
									</span>
								</c:when>
								<c:otherwise>
									<span class="pagebanner"> 
										Không có kết quả nào được tìm thấy
									</span>
								</c:otherwise>
							</c:choose>
							<br/>
							<!-- End Filter -->
							
							<!-- LINE CHART -->
							<jsp:include page="card-charging-chart.js.jsp" />
							<div id="line_chart" >
							  <svg style="height: 500px;"></svg>
							</div>
							
							<!-- PIE CHART -->
							<h1 class="srv_title">Biểu đồ thống kê</h1>
							
							<div id="status_type">
								<fieldset class="fieldset_filter" style="width: 46%; float: left;">
									<legend >
										<label style="text-align: left;"><b>Trạng thái</b></label>
									</legend>
									<span class="pie">
										<svg id="status_chart" class="pie_child_inline" ></svg>
									</span>
								</fieldset>
								<fieldset class="fieldset_filter" style="width: 46%;">
									<legend>
										<b>Loại thẻ</b>
									</legend>
									<span class="pie">
										<svg id="type_chart" class="pie_child_inline"></svg>
									</span>
								</fieldset>
							</div>
							<c:if test="${isOperator ||  isBizSupporter || isCustomerCare}">
								<fieldset class="fieldset_filter">
									<legend style="text-align: left;"><b>Nhà cung cấp</b>
									</legend>
									<span class="pie">
										<svg id="provider_chart" class="pie_child"></svg>
									</span>
								</fieldset>
							</c:if>
							
							<c:if test="${model.displayMerchant }">
								<fieldset class="fieldset_filter">
									<legend><b>Merchant</b>
									</legend>
									<span class="pie">
										<svg id="merchant_chart" class="pie_child"></svg>
									</span>
								</fieldset>
							</c:if>
						</div>
					</div>
				</div>
				<!-- / Body -->
			</div>
		</div>
		<!-- / Web Top -->

		<!-- Web Foot -->
		<jsp:include page="footer.jsp"></jsp:include>
		<!-- / Web Foot -->
	</div>
	<!-- / 1PAY WEB -->
	<script type="text/javascript">
		/*         */
		jQuery(function($) {

			$(function() {
				$('#hot_productslides').slides({
					preload : true,
					preloadImage : 'images/loading.gif',
					play : 5000,
					pause : 2500,
					hoverPause : true
				});
			});

		});
		/*   */
	</script>
	<!-- Create Menu Settings: (Menu ID, Is Vertical, Show Timer, Hide Timer, On Click ('all' or 'lev2'), Right to Left, Horizontal Subs, Flush Left, Flush Top) -->
	<script type="text/javascript">
		qm_create(0, false, 0, 250, false, false, false, false, false);
	</script>
	<!--[if IE]><iframe onload="on_script_loaded(function() { HashKeeper.reloading=false; });" style="display: none" name="hashkeeper" src="/blank" height="1" width="1" id="hashkeeper"></iframe><![endif]-->

</body>
</html>
