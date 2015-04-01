$(document).on "click", "#answer_session .voting button", () ->
  event.preventDefault()

  button = $(this)
  submit_path = $(this).parent().data("submit-path")
  question_path = $(this).parent().data("question-path")
  rating = $(this).data("value")
  type = $(this).parent().data("type")
  question_id = $(this).parent().data("question-id")


  badge = $(this).siblings(".rating").first()

  $.post(submit_path, {vote: {question_id: question_id, rating: rating}}, () ->
    button.siblings(".vote").first().addClass("btn-default").removeClass("btn-success").removeClass("btn-danger")


    button.removeClass("btn-default")

    if rating > 0
      button.addClass("btn-success")
    else
      button.addClass("btn-danger")

    if badge.length
      d3.json(question_path+".json", (error, q_data) ->
        badge.children().first().html(q_data.rating)
      )
  )

$(document).on "click", ".research_topics a.vote, #vote-counter a.vote, .research-topic a.vote", (event) ->
  event.preventDefault()


  research_topic_id = $(this).data("research-topic-id")
  data_type = $(this).data("type")

  #select the cast/retract button we want to be able to flip to cast/retract and vise versa
  if data_type == 'retract-counter'
    #the user has clicked the retract counter from the list of "my votes", so we need to find the original item in the list above
    link = $("a[data-research-topic-id='"+research_topic_id+"']")
  else
    # the user clicked the original item in the list, so the link is that btn
    link = $(this)


  link_text = ""
  badge = $(this).closest(".research-topic").find(".rating")

  submit_path = $(this).data("submit-path")
  research_topic_path = $(this).data("research-topic-path")
  vote_counter = $(".vote_counter")
  badge_list = $(".badge_list")


  vote_hash = {research_topic_id: research_topic_id}

  if $(this).data("type") == "cast"
    vote_hash["cast"] = "1"
    link_text = "Retract Vote"
    new_data = "retract"
  else
    vote_hash["retract"] = "1"
    link_text = "Cast Vote"
    new_data = "cast"

  post_hash = {vote: vote_hash }

  $.post(submit_path, post_hash, (data) ->
    if data.saved
      if data_type == 'retract-counter'
        # remove the item from the my votes section
        $(this).closest(".list-group-item").remove()

      #toggle the link text
      link.text(link_text)
      link.toggleClass('btn-primary').toggleClass("btn-default")
      link.data("type", new_data)


      if badge.length
        $.getJSON(research_topic_path+".json", (data) ->
          badge.html(data.rating)
        )

      if vote_counter.length
        $.get(vote_counter.data("target-path"), (data) ->
          vote_counter.html(data)
        )

      #update the badge list since it may have changed since voting!
      if badge_list.length
        $.get(badge_list.data("target-path"), (data) ->
          badge_list.html(data)
        )
    else
      bootbox.alert("Sorry! You have used all your votes. If you want to vote for this topic, first retract a vote from another.")
  )


$(document).on "click", ".research_topics a.disabled", (event) ->
  event.preventDefault()


#$(document).on "show.bs.tab", 'a[data-toggle="tab"]', (event) ->
#
#   target_path = $(event.target).data("target-path")
#   target_pane = $($(event.target).attr("href"))
#   target_pane.hide()
#
#   id = target_pane.attr("id")
#
#   $.get(target_path, { id: id}, (data) ->
#     target_pane.html(data)
#     target_pane.show()
#   )
