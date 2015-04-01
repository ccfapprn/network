$(function () {

  //var chart_start = $('#trend_data').data('chart-start');
  //var chart_one_json = $('#trend_data').data('chart-one');
  //var chart_one_json = '{"chart_one": [1,2,3,4,5,null,4,3,5]}';
  //var chart_two_json = $('#trend_data').data('chart-two');
  //var chart_one = $.map(chart_one_json, function(el) {return el;});

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
            type: 'datetime',
            minRange: 14 * 24 * 3600 * 1000 // fourteen days
	        //categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
	        //    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
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
	    series: [
	    {
            pointInterval: 24 * 3600 * 1000, //every day
            //pointStart: Date.UTC(2015, 2, 28),
            pointStart: Date.parse(chart_start),
	          yAxis: 0,
	          name: chart_one_name,
              data: chart_one_arr,
	          //data: [
	          //	2000, 3000, 4000, 5500, 5000, 5550, 4300, 5300, 5800, 5990,
	          //	2000, 3000, 4000, 5500, 5000, 5550, 4300, 5300, 5800, 5990,
	          //	2000, 3000, 4000, 5500, 5000, 5550, 4300, 5300, 5800, 5990
	          //	]
	    }, {
            pointInterval: 24 * 3600 * 1000, //every day
            //pointStart: Date.UTC(2015, 2, 28),
            pointStart: Date.parse(chart_start),
	          yAxis: 1,
	          name: chart_two_name,
              data: chart_two_arr,
	          //data: [
	          //	225, 230, 199, 220, 190, 150, 168, 145, 140, 135,
	          //	111, 122, 199, 122, 133, 150, 168, 145, 140, 135,
	          //	133, 122, 144, 144, 144, 150, 168, 145, 140, 135
	          //	]
	    }]
	});
});


/************************************
$(function () {
    $('#linechart').highcharts({
        chart: {
            zoomType: 'x'
        },
        title: {
            text: 'Steps mockup'
        },
        subtitle: {
            text: document.ontouchstart === undefined ?
                    'Click and drag in the plot area to zoom in' :
                    'Pinch the chart to zoom in'
        },
        xAxis: {
            type: 'datetime',
            minRange: 14 * 24 * 3600 * 1000 // fourteen days
        },
        yAxis: {
            title: {
                text: 'Exchange rate'
            }
        },
        legend: {
            enabled: false
        },
        plotOptions: {
            area: {
                fillColor: {
                    linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1},
                    stops: [
                        [0, Highcharts.getOptions().colors[0]],
                        [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                    ]
                },
                marker: {
                    radius: 2
                },
                lineWidth: 1,
                states: {
                    hover: {
                        lineWidth: 1
                    }
                },
                threshold: null
            }
        },

        series: [{
            type: 'area',
            name: 'USD to EUR',
            pointInterval: 24 * 3600 * 1000, //every day
            pointStart: Date.UTC(2015, 2, 1),
            data: [
            4400,
            4400,
            4400,
            4400,
            7800,
            4400,
            4400,
            4400,
            4400,
            4400,
            9900,
            4400,
            4400,
            4400,
            4400,
            4400,
            4400,
            1200,
            4400,
            4400,
            4400,
            null,
            4400,
            4400,
            4400,
            4400,
            4400,
            4400,
            4400,
            4400,
            ]
        }]
    });
});
********************************/