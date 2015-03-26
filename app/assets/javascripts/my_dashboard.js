$(function () {

  var health_today = $('#dashboard_data').data('health-today');
  var disease_type = $('#dashboard_data').data('disease-type');
  var disease_index = $('#dashboard_data').data('disease-index');
  var sleep = parseFloat( $('#dashboard_data').data('sleep') );
  var steps = $('#dashboard_data').data('steps');
  var calories_in = $('#dashboard_data').data('calories-in');
  var calories_out = $('#dashboard_data').data('calories-out');

  var gaugeOptions = {

      chart: {
          type: 'solidgauge'
      },

      title: null,

      pane: {
          center: ['50%', '85%'],
          size: '140%',
          startAngle: -90,
          endAngle: 90,
          background: {
              backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || '#EEE',
              innerRadius: '60%',
              outerRadius: '100%',
              shape: 'arc'
          }
      },

      tooltip: {
          enabled: false
      },

      // the value axis
      yAxis: {
          stops: [
              //[0.1, '#55BF3B'], // green
              //[0.5, '#DDDF0D'], // yellow
              //[0.9, '#DF5353'] // red
              [0.1, '#0091C3'], // ccfa blue
              [0.9, '#0091C3'], // ccfa blue
          ],
          lineWidth: 0,
          minorTickInterval: null,
          tickPixelInterval: 60,
          tickWidth: 2,
          title: {
              y: -70
          },
          labels: {
              y: 16
          }
      },

      plotOptions: {
          solidgauge: {
              dataLabels: {
                  y: 5,
                  borderWidth: 0,
                  useHTML: true
              },
            wrap: false,
          }
      }
  };


  var gaugeComingSoonOptions = {

      chart: {
          type: 'solidgauge'
      },

      title: null,

      pane: {
          center: ['50%', '85%'],
          size: '140%',
          startAngle: -90,
          endAngle: 90,
          background: {
              backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || '#EEE',
              innerRadius: '60%',
              outerRadius: '100%',
              shape: 'arc'
          }
      },

      tooltip: {
          enabled: false
      },

      // the value axis
      yAxis: {
          stops: [
              [0.1, '#DDDDDD'],
              [0.9, '#DDDDDD'] 
              //[0.1, '#55BF3B'], // green
              //[0.5, '#DDDF0D'], // yellow
              //[0.9, '#DF5353'] // red
          ],
          lineWidth: 0,
          minorTickInterval: null,
          tickPixelInterval: 60,
          tickWidth: 2,
          title: {
              y: -70
          },
          labels: {
              y: 16
          }
      },

      plotOptions: {
          solidgauge: {
              dataLabels: {
                  y: 5,
                  borderWidth: 0,
                  useHTML: true
              }
          }
      }
  };
  ;

  $('#gauge-health').highcharts(Highcharts.merge(gaugeOptions, {
      yAxis: {
          min: 0,
          max: 100,
          title: {
              text: 'Health Today'
              ,style: { fontSize: '23px'}
          }
      },

      credits: {
          enabled: false
      },

      series: [{
          name: 'Health Today',
          data: [ health_today ], //#{current_user.latest_check_in.summary['How are you feeling today?']}],
    
          dataLabels: {
              format: '<div style="text-align:center"><span style="font-size:25px;color:' +
                  ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>' +
                     '<span style="font-size:12px;color:silver">Health Today</span></div>'
          },
          tooltip: {
              valueSuffix: ' '
          }
      }]

  }));

  $('#gauge-cd').highcharts(Highcharts.merge(gaugeOptions, {
      yAxis: {
          min: 0,
          max: 700,
          title: {
              text: "Crohn's Disease Activity"
              ,style: { fontSize: '23px'}
          }
      },

      credits: {
          enabled: false
      },

      series: [{
          name: "Crohn's Disease Activity",
          data: [disease_index],
          dataLabels: {
              format: '<div style="text-align:center"><span style="font-size:25px;color:' +
                  ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>' +
                     '<span style="font-size:12px;color:silver">Disease Activity</span></div>'
          },
          tooltip: {
              valueSuffix: ' '
          }
      }]

  }));

  // The DI gauge
  $('#gauge-uc').highcharts(Highcharts.merge(gaugeOptions, {
      yAxis: {
          min: 0,
          max: 12,
          title: {
              text: 'UC/IC Disease Activity'
              ,style: { fontSize: '23px'}
          }
      },

      credits: {
          enabled: false
      },

      series: [{
          name: 'UC/IC Disease Activity',
          data: [disease_index],
          dataLabels: {
              format: '<div style="text-align:center"><span style="font-size:25px;color:' +
                  ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>' +
                     '<span style="font-size:12px;color:silver">Disease Activity</span></div>'
          },
          tooltip: {
              valueSuffix: ' '
          }
      }]

  }));


  // The SLEEP gauge
  $('#gauge-sleep').highcharts(Highcharts.merge(gaugeOptions, {
      yAxis: {
          min: 0,
          max: 10,
          title: {
              text: 'Sleep'
              ,style: { fontSize: '23px'}
          }
      },

      credits: {
          enabled: false
      },

      series: [{
          name: 'Sleep',
          data: [sleep],
          dataLabels: {
              format: '<div style="text-align:center"><span style="font-size:25px;color:' +
                  ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>' +
                     '<span style="font-size:12px;color:silver">Hours of Sleep</span></div>'
          },
          tooltip: {
              valueSuffix: ' '
          }
      }]

  }));

  $('#gauge-step').highcharts(Highcharts.merge(gaugeOptions, {
      yAxis: {
          min: 0,
          max: 12000,
          title: {
              text: 'Steps'
              ,style: { fontSize: '23px'}
          }
      },

      credits: {
          enabled: false
      },

      series: [{
          name: 'Steps',
          data: [steps],
          dataLabels: {
              format: '<div style="text-align:center"><span style="font-size:25px;color:' +
                  ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>' +
                     '<span style="font-size:12px;color:silver">Steps</span></div>'
          },
          tooltip: {
              valueSuffix: ' '
          }
      }]

  }));


  $('#gauge-calories_in').highcharts(Highcharts.merge(gaugeOptions, {
      yAxis: {
          min: 0,
          max: 6000,
          title: {
              text: 'Dietary Calories'
              ,style: { fontSize: '23px'}
          }
      },

      credits: {
          enabled: false
      },

      series: [{
          name: 'Dietary Calories',
          data: [calories_in],
          dataLabels: {
              format: '<div style="text-align:center"><span style="font-size:25px;color:' +
                  ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>' +
                     '<span style="font-size:12px;color:silver">Calories</span></div>'
          },
          tooltip: {
              valueSuffix: ' '
          }
      }]

  }));

  $('#gauge-calories_out').highcharts(Highcharts.merge(gaugeOptions, {
      yAxis: {
          min: 0,
          max: 6000,
          title: {
              text: 'Calories Burned'
              ,style: { fontSize: '23px'}
          }
      },

      credits: {
          enabled: false
      },

      series: [{
          name: 'Calories Burned',
          data: [calories_out],
          dataLabels: {
              format: '<div style="text-align:center"><span style="font-size:25px;color:' +
                  ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>' +
                     '<span style="font-size:12px;color:silver">Calories</span></div>'
          },
          tooltip: {
              valueSuffix: ' '
          }
      }]

  }));

  // The COMING SOON SLEEP gauge
  $('#gauge-sleep-coming-soon').highcharts(Highcharts.merge(gaugeComingSoonOptions, {
      yAxis: {
          min: 0,
          max: 10,
          title: {
              text: 'COMING SOON - Sleep'
              ,style: { fontSize: '23px'}
          }
      },

      credits: {
          enabled: false
      },

      series: [{
          name: 'Sleep',
          data: [0],
          dataLabels: {
              format: '<div style="text-align:center"><span style="font-size:25px;color:' +
                  ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>' +
                     '<span style="font-size:12px;color:silver">Hours of Sleep</span></div>'
          },
          tooltip: {
              valueSuffix: ' '
          }
      }]

  }));

  $('#gauge-step-coming-soon').highcharts(Highcharts.merge(gaugeComingSoonOptions, {
      yAxis: {
          min: 0,
          max: 12000,
          title: {
              text: 'COMING SOON - Steps'
              ,style: { fontSize: '23px'}
          }
      },

      credits: {
          enabled: false
      },

      series: [{
          name: 'Steps',
          data: [0],
          dataLabels: {
              format: '<div style="text-align:center"><span style="font-size:25px;color:' +
                  ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>' +
                     '<span style="font-size:12px;color:silver">Steps</span></div>'
          },
          tooltip: {
              valueSuffix: ' '
          }
      }]

  }));

});