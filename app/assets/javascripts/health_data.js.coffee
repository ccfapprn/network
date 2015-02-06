
## might need to be mouseup because of IE trouble
$(document).on "change", "#check-in input[type='range']", (event) ->
  $("#check-in #range-value").val($(this).val())

# Move to the next question when .next DOM elements are touched
$(document).on "click", "#check-in .next", (event) ->
  event.preventDefault()
  #alert()
  $("#question_" + $(this).attr('data-this-question-id')).addClass("hidden")
  $("#question_" + $(this).attr('data-next-question-id')).removeClass("hidden")

