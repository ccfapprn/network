$(function () {

	$('#linechart').highcharts({
	      credits: {
          	enabled: false
      	},
	    title: {
	        text: 'COMING SOON! Health Tracking',
	        x: -20 //center
	    },
	    subtitle: {
	        text: 'Source: data for demonstration only',
	        x: -20
	    },
	    xAxis: {
	        categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
	            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
	    },
	    yAxis: [
	      {
	          title: {
	              text: 'Steps per day'
	          },
	      },
	      {
	          title: {
	              text: 'Disease Activity'
	          },
	      opposite: true
	      },
	    ],
	    tooltip: {
	          valueSuffix: ''
	    },
	    legend: {
	          layout: 'vertical',
	          align: 'right',
	          verticalAlign: 'middle',
	          borderWidth: 0
	    },
	    series: [{
	          yAxis: 0,
	          name: 'Steps',
	          data: [2000, 3000, 4000, 5500, 5000, 5550, 4300, 5300, 5800, 5990, 6500, 6900]
	    }, {
	          yAxis: 1,
	          name: 'Disease Activity',
	          data: [225, 230, 199, 220, 190, 150, 168, 145, 140, 135, 150, 120]
	    }]
	});

});