<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script>
	var oneDayMilis = 24*60*60*1000;
	var period = 0.1; //0.1h

	var listAll = [], listSuccess = [], listError = [], listWrong = [], limitError = [];
	//var maxFrame = parseFloat('<c:out value="${model.total}"/>') / (24.0/period);
	var countLimit = 3;
	
	///////////////////////////////////////// LINE =============================================
	//curr
	var mapHistogram = [];
	<c:forEach var="map" items="${model.dataHistogramMap }">
		///alert('<c:out value="${map.key}"/>');
		var listInterval = [];
		<c:forEach var="item" items="${map.value }">
			listInterval.push({key : parseInt('<c:out value="${item.key}"/>'), count : parseInt('<c:out value="${item.count}"/>')});
		</c:forEach>
		mapHistogram.push({key : '<c:out value="${map.key}"/>', list : listInterval});
	</c:forEach>
	
	//alert(new Date(mapHistogram[0].list[0].key));
	
	draw();
	
	function draw() {
		
		var chart;

		nv.addGraph(function() {
			
			chart = nv.models.lineChart()
            .margin({left: 100, bottom:100})  //Adjust chart margins to give the x-axis some breathing room.
            //.useInteractiveGuideline(true)  //We want nice looking tooltips and a guideline!
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
		//var to_date = '<c:out value="${param.to_date}"/>';
		
		var today = new Date();
		if(from_date == '' || Date.parseExact(from_date, 'dd/MM/yyyy') == null){
			//from_date = '<c:out value="${model.from_date}"/>';
			from_date = (today.getDate() <10 ?'0'+today.getDate():today.getDate()) +'/' + (today.getMonth() +1) + '/' +today.getFullYear();
		}
		
		//Analytic
		//var period = 0.1;
		var fromDate = Date.parseExact(from_date, 'dd/MM/yyyy');
		var hours = 24;//(fromDate.getTime() - fromDate.getTime())/(60*60*1000) + 1;
		//var day = Math.floor((toDate.getTime() - fromDate.getTime())/(24*60*60*1000)) + 1;
		
		var levels = hours / period; 
		
		var levelTimeAll = generateTemplateTimePeriod(period, fromDate, fromDate, hours, levels);
		function generateTemplateTimePeriod(period, fromDate, toDate, hours, levels){
			var levelTime = [];
			for(var i = 0; i < levels; i++){
				levelTime.push(fromDate.getTime() + i*period*60*60*1000);
			}
			
			return levelTime;
		}
		
		//alert(levelTimeAll[0]);
		
		function generateLineCoordinates() {
			//To fill missions
			for (var i = 0; i < levelTimeAll.length; i++) {
				limitError.push({x : new Date(parseInt(levelTimeAll[i])) , y : countLimit});
				
				//map
				for(var j = 0; j < mapHistogram.length; j++){
					
					if (mapHistogram[j].list == '' || (mapHistogram[j].list.length - 1) < i
							|| levelTimeAll[i] != mapHistogram[j].list[i].key) {
						var blank = {
							key : levelTimeAll[i],
							count : 0
						};
						
						mapHistogram[j].list.splice(i, 0, blank);
					}
				}
			}
			//alert(mapHistogram[0].list[100].count);
			
			var mapXY = [];
			for(var j = 0; j < mapHistogram.length; j++){
				var listXY = [];
				for (var i = 0; i < levelTimeAll.length; i++) {
					//map
					listXY.push({x : new Date(parseInt(mapHistogram[j].list[i].key)) , y : mapHistogram[j].list[i].count});
					
				}
				mapXY.push({key : mapHistogram[j].key , list : listXY});
			}
			
			var results = [];
			for(var j = 0; j < mapXY.length; j++){
				results.push({
					values : mapXY[j].list,
					key : mapXY[j].key
					
				});
			}
			
			results.push({
				values : limitError,
				key : 'Giới hạn'
			});
			
			return results;
		}
	}
	//End LINE
	
	/////////////////////PIE===============================
	var tab = '<c:out value="${param.tab}"/>';
	var topData = [];
	if(tab == '' || tab == 'subscriber' || tab != 'merchant'){
		<c:forEach var="item" items="${model.topData }">
			topData.push({key : '<c:out value="${item.msisdn}"/>' , y : '<c:out value="${item.amount}"/>'});
		</c:forEach>
	}
	else{
		<c:forEach var="item" items="${model.topData }">
			topData.push({key : '<c:out value="${item.merchant}"/>' , y : '<c:out value="${item.amount}"/>'});
		</c:forEach>
	}
	
	var inline_w = 400;
	var inline_h = 400;
	drawPie(topData, 'data', inline_w, inline_h, '#pie_chart');
	function drawPie(data, field, width, height, id) {
		//alert(data);
		nv.addGraph(function() {

			var chart = nv.models.pieChart().x(function(d) {
				return d.key;
			}).y(function(d) {
				return d.y;
			}).color(d3.scale.category20().range())
			.width(width).height(height)
			.margin({left: -100, top: -200})
			.labelType("percent");

			d3.select(id).datum(data).transition().duration(1200)
				.attr('width', width)
				.attr('height', height)
				.call(chart);

			chart.dispatch.on('stateChange', function(e) {
				nv.log('New State:', JSON.stringify(e));
			});

			return chart;
		});
		
	}
	
	//END PIE
</script>