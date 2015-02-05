toggle_confirm_disease = ->
  if $("#confirm_disease").is(":checked")
    
    #$('#join_button_div').removeClass("hidden");
    #$('#join_button_div .btn').prop('value','Sign Up');
    $("#join_button_div .btn").prop "disabled", false
  else
    
    #$('#join_button_div').addClass("hidden");
    $("#join_button_div .btn").prop "disabled", true
toggle_confirm_disease()
$("#confirm_disease").on "click", (e) ->
  toggle_confirm_disease()
