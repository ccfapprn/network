//$(function () {
function my_trend_render() {

  //var chart_start = $('#trend_data').data('chart-start');
  //var chart_one_json = $('#trend_data').data('chart-one');
  //var chart_one_json = '{"chart_one": [1,2,3,4,5,null,4,3,5]}';
  //var chart_two_json = $('#trend_data').data('chart-two');
  //var chart_one = $.map(chart_one_json, function(el) {return el;});

  var chart_subtitle = '';
  if( chart_one_name != '' && chart_two_name != '')
    chart_subtitle = chart_one_name + ' vs ' + chart_two_name;
  else if( chart_one_name != '' )
    chart_subtitle = chart_one_name;
  else if( chart_two_name != '' )
    chart_subtitle = chart_two_name;


  var chart_one_title = 'select first measure';
  var chart_two_title = 'select second measure';
  if( chart_one_name != '' )
    chart_one_title = chart_one_name;
  if( chart_two_name != '' )
    chart_two_title = chart_two_name;

	$('#linechart').highcharts({
	      credits: {
          	enabled: false
      	},
	    title: {
	        text: 'Health Tracking',
	        x: -20 //center
	    },
	    subtitle: {
	        text: chart_subtitle,
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
	              text: chart_one_title
	          },
	      },
	      {
	          title: {
	              text: chart_two_title
	          },
	      opposite: true
	      },
	    ],
	    tooltip: {
	          valueSuffix: '',
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
              marker: { enabled: true, radius: 4},
	          name: chart_one_title,
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
              marker: { enabled: true, radius: 4},
	          name: chart_two_title,
              data: chart_two_arr,
	          //data: [
	          //	225, 230, 199, 220, 190, 150, 168, 145, 140, 135,
	          //	111, 122, 199, 122, 133, 150, 168, 145, 140, 135,
	          //	133, 122, 144, 144, 144, 150, 168, 145, 140, 135
	          //	]
	    }]
	});
};
