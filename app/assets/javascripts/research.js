$(function() {

  function research_priority_explain(category)
  {
    var message = [];
    message['top_priority'] = 'This question is a good fit for our network and has not been answered yet. We are currently trying to match this question with the right IBD Researcher for a study.';
    message['in_progress'] = 'An IBD Researcher in our network is in the process of designing a study to answer this question. Stay tuned!';
    message['being_researched'] = 'A study is already underway that aims to answer this question. Check out the comment section associated with this question to learn more.';
    message['completed'] = 'This question has already been answered by a prior CCFA Partners study. Check out the comment section associated with this question to learn what was discovered.';
    message['better_answered_elsewhere'] = 'This question is a good one, but better answered by a research group outside the CCFA Partners network. For more information, check out the comment section associated with this question.';
    message['answered_by_others'] = 'This question has already been answered by a research group outside our network. Check out the comments section associated with this question to learn what was discovered.';

    var alert_message = "Voting has been disabled. This question received enough votes to be considered one of the most popular in our network.<br /><br />"
    alert_message += message[category];

    bootbox.alert(alert_message);
  }

    $(".research_priority").click( function(e) {
      //bootbox.alert("bootbox hello");
      research_priority_explain($(this).attr('data-category'));
      return false;
    });

  });