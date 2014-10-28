<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script>
	var oneDayMilis = 24*60*60*1000;
	var period = 0.1; //0.1h

	var listAll = [], listSuccess = [], listError = [], listWrong = [], limitError = [];
	var maxFrame = parseFloat('<c:out value="${model.total}"/>') / (24.0/period);
	var countLimit = 1;//maxFrame / 100 * 2; 2%
	
	var listAllLast = [], listSuccessLast = [], listErrorLast = [], listWrongLast = [], limitErrorLast = [];
	
	///////////////////////////////////////// LINE =============================================
	//curr
	<c:forEach var="item" items="${model.statusHistogramMap['successStatus'] }">
		listSuccess.push({key : parseInt('<c:out value="${item.key}"/>'), count : parseInt('<c:out value="${item.count}"/>')});
	</c:forEach>
	<c:forEach var="item" items="${model.statusHistogramMap['errorStatus'] }">
		listError.push({key : parseInt('<c:out value="${item.key}"/>'), count : parseInt('<c:out value="${item.count}"/>')});
	</c:forEach>
	<c:forEach var="item" items="${model.statusHistogramMap['invalidStatus'] }">
		listWrong.push({key : parseInt('<c:out value="${item.key}"/>'), count : parseInt('<c:out value="${item.count}"/>')});
	</c:forEach>
	<c:forEach var="item" items="${model.statusHistogramMap['allStatus'] }">
		listAll.push({key : parseInt('<c:out value="${item.key}"/>'), count : parseInt('<c:out value="${item.count}"/>')});
	</c:forEach>
	
	//last
	<c:forEach var="item" items="${model.statusHistogramMapLast['successStatus'] }">
		listSuccessLast.push({key : parseInt('<c:out value="${item.key}"/>'), count : parseInt('<c:out value="${item.count}"/>')});
	</c:forEach>
	<c:forEach var="item" items="${model.statusHistogramMapLast['errorStatus'] }">
		listErrorLast.push({key : parseInt('<c:out value="${item.key}"/>'), count : parseInt('<c:out value="${item.count}"/>')});
	</c:forEach>
	<c:forEach var="item" items="${model.statusHistogramMapLast['invalidStatus'] }">
		listWrongLast.push({key : parseInt('<c:out value="${item.key}"/>'), count : parseInt('<c:out value="${item.count}"/>')});
	</c:forEach>
	<c:forEach var="item" items="${model.statusHistogramMapLast['allStatus'] }">
		//alert(new Date('<c:out value="${item.key}"/>'));
		listAllLast.push({key : parseInt('<c:out value="${item.key}"/>'), count : parseInt('<c:out value="${item.count}"/>')});
	</c:forEach>
	
	//alert(new Date(listAllLast[0].key));
	//alert(listSuccessLast[0].count);
	var statusPicked = '<c:out value="${param.filter_status}"/>';
	
	draw(listAll, listAllLast, $('#comparation').is(':checked'), statusPicked);
	
	$('#comparation').change('click', function(){
		
		$('#line_chart svg').empty();
		
		var val = $(this).is(':checked');
		//alert(statusPicked == '');
		draw(listAll, listAllLast, val, statusPicked);
	});	
	
	function draw(listCrr, listLast, compare, statusPicked) {
		var json = listCrr;
		
		var chart;

		nv.addGraph(function() {
			/* chart = nv.models.lineChart().options({
				margin : {
					left : 100,
					bottom : 100
				},
				showXAxis : true,
				showYAxis : true,
				transitionDuration : 250
			}); */
			chart = nv.models.lineChart()
            .margin({left: 100, bottom:100})  //Adjust chart margins to give the x-axis some breathing room.
            .useInteractiveGuideline(true)  //We want nice looking tooltips and a guideline!
            .transitionDuration(350)  //how fast do you want the lines to transition?
            .showLegend(true)       //Show the legend, allowing users to turn on/off line series.
            .showYAxis(true)        //Show the y-axis
            .showXAxis(true)        //Show the x-axis
			;
            
			chart.yAxis.axisLabel('Số lượng').tickFormat(d3.format(',.1f')); //,.2f //d

			chart.xAxis
			.rotateLabels(-20)
			.tickFormat(function(d) {
				return new Date(d).toString("dd/MM/yyyy HH:mm");
			});
			
			d3.select('#line_chart svg').datum(generateLineCoordinates()).call(
					chart);

			//TODO: Figure out a good way to do this automatically
			nv.utils.windowResize(chart.update);
			//nv.utils.windowResize(function() { d3.select('#chart1 svg').call(chart) });

			chart.dispatch.on('stateChange', function(e) {
				nv.log('New State:', JSON.stringify(e));
			});

			return chart;
		});
		
		var from_date = '<c:out value="${param.from_date}"/>';
		var to_date = '<c:out value="${param.to_date}"/>';
		
		var today = new Date();
		if(from_date == '' || Date.parseExact(from_date, 'dd/MM/yyyy HH:mm') == null){
			//from_date = '<c:out value="${model.from_date}"/>';
			from_date = (today.getDate() <10 ?'0'+today.getDate():today.getDate()) +'/' + (today.getMonth() +1) + '/' +today.getFullYear() + ' 00:00';
		}
		if(to_date == '' || Date.parseExact(to_date, 'dd/MM/yyyy HH:mm') == null){
			//to_date = '<c:out value="${model.to_date}"/>';
			to_date = (today.getDate() <10 ?'0'+today.getDate():today.getDate()) +'/' + (today.getMonth() +1) + '/' +today.getFullYear() + ' 23:00';
		}
		//alert(to_date);
		
		//Analytic
		//var period = 0.1;
		var fromDate = Date.parseExact(from_date, 'dd/MM/yyyy HH:mm');
		var toDate = Date.parseExact(to_date, 'dd/MM/yyyy HH:mm');
		var hours = (toDate.getTime() - fromDate.getTime())/(60*60*1000) + 1;
		var day = Math.floor((toDate.getTime() - fromDate.getTime())/(24*60*60*1000)) + 1;
		//alert(day);
		var levels = hours / period; 
		
		var levelTimeAll = generateTemplateTimePeriod(period, fromDate, toDate, hours, levels);
		var levelTimeAllLast = generateTemplateTimePeriodLast(period, fromDate, toDate, hours, day, levels);
		
		//alert(new Date(levelTimeAllLast[0]));
		
		function generateTemplateTimePeriod(period, fromDate, toDate, hours, levels){
			var levelTime = [];
			for(var i = 0; i < levels; i++){
				levelTime.push(fromDate.getTime() + i*period*60*60*1000);
			}
			
			return levelTime;
		}
		
		function generateTemplateTimePeriodLast(period, fromDate, toDate, hours, day, levels){
			var levelTime = [];
			for(var i = 0; i < levels; i++){
				levelTime.push(fromDate.getTime() - day*oneDayMilis + i*period*60*60*1000);
			}
			
			return levelTime;
		}
		
		function generateLineCoordinates() {
			//To fill missions
			for (var i = 0; i < levelTimeAll.length; i++) {
				limitError.push({key : levelTimeAll[i], count : countLimit});
				
				if (listCrr == '' || (listCrr.length - 1) < i
						|| levelTimeAll[i] != listCrr[i].key) {
					var blank = {
						key : levelTimeAll[i],
						count : 0
					};
					
					listCrr.splice(i, 0, blank);
				}
				
				if (listSuccess == '' || (listSuccess.length - 1) < i
						|| levelTimeAll[i] != listSuccess[i].key) {
					var blank = {
						key : levelTimeAll[i],
						count : 0
					};
					listSuccess.splice(i, 0, blank);
				}
				
				if (listError == '' || (listError.length - 1) < i
						|| levelTimeAll[i] != listError[i].key) {
					var blank = {
						key : levelTimeAll[i],
						count : 0
					};
					listError.splice(i, 0, blank);
				}
				
				if (listWrong == '' || (listWrong.length - 1) < i
						|| levelTimeAll[i] != listWrong[i].key) {
					var blank = {
						key : levelTimeAll[i],
						count : 0
					};
					listWrong.splice(i, 0, blank);
				}
				
				//compare
				if(compare== true){
					//alert(new Date(listLast[i].key)+ ' : ' + new Date(levelTimeAllLast[i]));
					if (listLast == '' || (listLast.length - 1) < i
							|| levelTimeAllLast[i] != listLast[i].key) {
						var blank = {
							key : levelTimeAllLast[i],
							count : 0
						};
						
						listLast.splice(i, 0, blank);
					}
					//alert(listLast[0].count);
					
					if (listSuccessLast == '' || (listSuccessLast.length - 1) < i
							|| levelTimeAllLast[i] != listSuccessLast[i].key) {
						var blank = {
							key : levelTimeAllLast[i],
							count : 0
						};
						listSuccessLast.splice(i, 0, blank);
					}
					
					if (listErrorLast == '' || (listErrorLast.length - 1) < i
							|| levelTimeAllLast[i] != listErrorLast[i].key) {
						var blank = {
							key : levelTimeAllLast[i],
							count : 0
						};
						listErrorLast.splice(i, 0, blank);
					}
					
					if (listWrongLast == '' || (listWrongLast.length - 1) < i
							|| levelTimeAllLast[i] != listWrongLast[i].key) {
						var blank = {
							key : levelTimeAllLast[i],
							count : 0
						};
						listWrongLast.splice(i, 0, blank);
					}
					
				} 
			}
			//alert(listLast[10].count);
			var lineTotal = [], lineSuccess = [], lineError = [], lineWrong = [], lineLimit = [];
			var lineTotalLast = [], lineSuccessLast = [], lineErrorLast = [], lineWrongLast = [];
			
			for (var i = 0; i < levelTimeAll.length; i++) {
				lineTotal.push({
					x : new Date(parseInt(listCrr[i].key)),
					y : listCrr[i].count
				});

				lineSuccess.push({
					x : new Date(parseInt(listSuccess[i].key)),
					y : listSuccess[i].count
				});

				lineError.push({
					x : new Date(parseInt(listError[i].key)),
					y : listError[i].count
				});
				lineWrong.push({
					x : new Date(parseInt(listWrong[i].key)),
					y : listWrong[i].count
				});
				
				lineLimit.push({
					x : new Date(parseInt(limitError[i].key)),
					y : limitError[i].count
				});
				
				//compare
				if(compare== true){
					lineTotalLast.push({
						x : new Date(parseInt(listLast[i].key) + day*oneDayMilis),
						y : listLast[i].count
					});

					lineSuccessLast.push({
						x : new Date(parseInt(listSuccessLast[i].key) + day*oneDayMilis),
						y : listSuccessLast[i].count
					});

					lineErrorLast.push({
						x : new Date(parseInt(listErrorLast[i].key) + day*oneDayMilis),
						y : listErrorLast[i].count
					});
					lineWrongLast.push({
						x : new Date(parseInt(listWrongLast[i].key) + day*oneDayMilis),
						y : listWrongLast[i].count
					});
				}

			}
			
			return getListToDisplay(compare, statusPicked, lineTotal, lineSuccess, lineError, lineWrong, lineLimit, lineTotalLast, lineSuccessLast, lineErrorLast, lineWrongLast);
		}
		
		function getListToDisplay(compare, status, lineTotal, lineSuccess, lineError, lineWrong, lineLimit, lineTotalLast, lineSuccessLast, lineErrorLast, lineWrongLast){
			//alert(compare);
			if(compare == false){
				if(status == 'successStatus'){
					return [{
						area:true,
						values : lineSuccess,
						key : "Thành công",
						color : "#2ca02c"
					}];
				} else
				if(status == 'invalidStatus'){
					return [{
						area:true,
						values : lineWrong,
						key : "Thẻ sai",
						color : "#DAA520"
					}];
				} else
				if(status == 'errorStatus'){
					return [{
						area:true,
						values : lineError,
						key : "Thẻ lỗi",
						color : "#FF0000"
					},
					{
						area:true,
						values : lineLimit,
						key : "Giới hạn lỗi",
						color : "#FA8072"
					}];
				} else{
					//alert(lineSuccess);
					return [ {
						area:true,
						values : lineTotal,
						key : "Tất cả",
						color : "#2222ff"
					}
					 , {
						 area:true,
						values : lineSuccess,
						key : "Thành công",
						color : "#2ca02c"
					}
					, {
						area:true,
						values : lineWrong,
						key : "Thẻ sai",
						color : "#DAA520"
					}  
					, {
						area:true,
						values : lineError,
						key : "Thẻ lỗi",
						color : "#FF0000"
					}
					, {
						area:true,
						values : lineLimit,
						key : "Giới hạn lỗi",
						color : "#FA8072"
					}
					];
				}
			} else{
				if(status == 'successStatus'){
					return [{
						area:true,
						values : lineSuccess,
						key : "Thành công",
						color : "#2ca02c"
					}, 
					{
						area:true,
						values : lineSuccessLast,
						key : "Thành công cùng kỳ",
						color : "#80c680"
					}];
				} else
				if(status == 'invalidStatus'){
					return [{
						area:true,
						values : lineWrong,
						key : "Thẻ sai",
						color : "#DAA520"
					}, 
					{
						area:true,
						values : lineWrongLast,
						key : "Thẻ sai cùng kỳ",
						color : "#ecd28f"
					} ];
				} else
				if(status == 'errorStatus'){
					return [{
						area:true,
						values : lineError,
						key : "Thẻ lỗi",
						color : "#FF0000"
					}, 
					{
						area:true,
						values : lineErrorLast,
						key : "Thẻ lỗi cùng kỳ",
						color : "#ffb2b2"
					},
					{
						area:true,
						values : lineLimit,
						key : "Giới hạn lỗi",
						color : "#FA8072"
					}];
				} else{
					return [ {
						area:true,
						values : lineTotal,
						key : "Tất cả",
						color : "#2222ff"
					}
					,{
						area:true,
						values : lineTotalLast,
						key : "Tất cả cùng kỳ",
						color : "#9090ff"
					}
					 , {
						 area:true,
						values : lineSuccess,
						key : "Thành công",
						color : "#2ca02c"
					}
					 , {
						area:true,
						values : lineSuccessLast,
						key : "Thành công cùng kỳ",
						color : "#80c680"
						}
					, {
						area:true,
						values : lineWrong,
						key : "Thẻ sai",
						color : "#DAA520"
					}  
					, {
						area:true,
						values : lineWrongLast,
						key : "Thẻ sai cùng kỳ",
						color : "#ecd28f"
					} 
					, {
						area:true,
						values : lineError,
						key : "Thẻ lỗi",
						color : "#FF0000"
					}
					, {
						area:true,
						values : lineErrorLast,
						key : "Thẻ lỗi cùng kỳ",
						color : "#ffb2b2"
					}
					, {
						area:true,
						values : lineLimit,
						key : "Giới hạn lỗi",
						color : "#FA8072"
					}
					];
				}
			}
		}
	}
	//End LINE

	////////////////////////////////////// PIE ==================================================
	//checkRolesForDisplayProvider
	function checkRolesForDisplayProvider(){
		var isOperator = '<c:out value="${isOperator}"/>';
		var isBizSupporter = '<c:out value="${isBizSupporter}"/>';
		var isCustomerCare = '<c:out value="${isCustomerCare}"/>';
		
		if(isOperator == 'true' || isBizSupporter == 'true' || isCustomerCare == 'true')
			return true;
		return false;
	}
	function checkRolesForDisplayMerchant(){
		var displayMerchant = '<c:out value="${model.displayMerchant }"/>';
		
		if(displayMerchant == 'true')
			return true;
		return false;
	}
	
	var statusSuccess = [];
	var statusError = [];
	var statusWrong = [];
	<c:forEach var="item" items="${model.successStatus }">
		statusSuccess.push('<c:out value="${item}"/>');
	</c:forEach>
	<c:forEach var="item" items="${model.invalidStatus }">
		statusWrong.push('<c:out value="${item}"/>');
	</c:forEach>
	<c:forEach var="item" items="${model.errorStatus }">
		statusError.push('<c:out value="${item}"/>');
	</c:forEach>
	
	var statusFacet = [], typeFacet = [], providerFacet = [], merchantFacet = [];	
	
	<c:forEach var="item" items="${model.facetsMap['status'] }">
		statusFacet.push({term : '<c:out value="${item.term}"/>', count : '<c:out value="${item.count}"/>'});
	</c:forEach>
	<c:forEach var="item" items="${model.facetsMap['type'] }">
		typeFacet.push({term : '<c:out value="${item.term}"/>', count : '<c:out value="${item.count}"/>'});
	</c:forEach>
	<c:forEach var="item" items="${model.facetsMap['paymentProvider'] }">
		//alert('<c:out value="${item.count}"/>');
		providerFacet.push({term : '<c:out value="${item.term}"/>', count : '<c:out value="${item.count}"/>'});
	</c:forEach>
	<c:forEach var="item" items="${model.facetsMap['merchant'] }">
		merchantFacet.push({term : '<c:out value="${item.term}"/>', count : '<c:out value="${item.count}"/>'});
	</c:forEach>
	
	//reset if pick another date
	if(providerFacet != '' && providerFacet.length == 1 && providerFacet[0].count == 0){
		providerFacet = [];
	}
	if(typeFacet != '' && typeFacet.length == 1 && typeFacet[0].count == 0){
		typeFacet = [];
	}
	if(merchantFacet != '' && merchantFacet.length == 1 && merchantFacet[0].count == 0){
		merchantFacet = [];
	}
		
	var size_chart_w = 500;
	var size_chart_h = 500;
	var inline_w = 300;
	var inline_h = 300;
	drawPie(statusFacet, 'status', inline_w, inline_h, '#status_chart');
	drawPie(typeFacet, 'type', inline_w, inline_h, '#type_chart');
	if(checkRolesForDisplayProvider())
		drawPie(providerFacet, 'paymentProvider', size_chart_w, size_chart_h, '#provider_chart');
	if(checkRolesForDisplayMerchant())
		drawPie(merchantFacet, 'merchant', size_chart_w, size_chart_h, '#merchant_chart');
	
	function drawPie(json, field, width, height, id) {
		if (field == 'status') {
			var statusArrays = [];
			var successCount = 0;
			var errorCount = 0;
			var wrongCount = 0;
			
			if(json != ''){
				$.each(json, function(k, v) {
	
					$.each(statusSuccess, function(i, item) {
	
						if (item == v.term)
							successCount += parseInt(v.count);
					});
	
					$.each(statusError, function(i, item) {
						if (item == v.term) {
							errorCount += parseInt(v.count);
						}
					});
	
					$.each(statusWrong, function(i, item) {
						if (item == v.term)
							wrongCount += parseInt(v.count);
					});
	
				});
				
				statusArrays.push({
					key : 'Thành công ',
					value : successCount
				});
				statusArrays.push({
					key : 'Thẻ lỗi ',
					value : errorCount
				});
				statusArrays.push({
					key : 'Thẻ sai ',
					value : wrongCount
				});
			}
			
			nv.addGraph(function() {
				var colors = [ "#2ca02c", "#FF0000", "#DAA520" ];
				var chart = nv.models.pieChart().x(function(d) {
					return d.key;
				}).y(function(d) {
					return d.value;
				}).color(colors) //d3.scale.category10().range()
				.width(width).height(height).labelType("percent");

				d3.select(id).datum(statusArrays).transition().duration(1200)
						.attr('width', width).attr('height', height)
						.call(chart);

				chart.dispatch.on('stateChange', function(e) {
					nv.log('New State:', JSON.stringify(e));
				});

				return chart;
			});
		} else {
			//alert(json);
			nv.addGraph(function() {

				var chart = nv.models.pieChart().x(function(d) {
					return d.term;
				}).y(function(d) {
					return d.count;
				}).color(d3.scale.category20().range()) //d3.scale.category10().range()
				.width(width).height(height).labelType("percent");

				d3.select(id).datum(json).transition().duration(1200).attr(
						'width', width).attr('height', height).call(chart);

				chart.dispatch.on('stateChange', function(e) {
					nv.log('New State:', JSON.stringify(e));
				});

				return chart;
			});
		}
	}

	//End PIE
</script>