Turbolinks.enableProgressBar();

$.rails.allowAction = (element) ->
  # The message is something like "Are you sure?"
  title = element.data('confirm')
  message = element.data('description')
  # If there's no message, there's no data-confirm attribute,
  # which means there's nothing to confirm
  return true unless message
  # Clone the clicked element (probably a delete link) so we can use it in the dialog box.
  $link = element.clone()
  # We don't necessarily want the same styling as the original link/button.
  .removeAttr('class')
  # We don't want to pop up another confirmation (recursion)
  .removeAttr('data-confirm')
  # We want a button
  .addClass('btn').addClass('btn-danger')
  # We want it to sound confirmy
  .html("Yes, I'm positively certain.")

  # Create the modal box with the message
  modal_html = """
               <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                 <div class="modal-dialog">
                   <div class="modal-content">
                     <div class="modal-header">
                       <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                       <h4 class="modal-title" id="myModalLabel">#{title}</h4>
                     </div>
                     <div class="modal-body">
                       #{message}
                     </div>
                     <div class="modal-footer">
                       <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                      </div>
                   </div>
                 </div>
               </div>

               """
  $modal_html = $(modal_html)
  # Add the new button to the modal box
  $modal_html.find('.modal-footer').append($link)
  # Pop it up
  $modal_html.modal()
  # Prevent the original link from working
  return false


@mainLoader = () ->
  $("select[rel=chosen]").chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    width: '100%'

  $(".chosen").chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    width: '100%'

  $(document.links).filter(() ->
    return this.hostname != window.location.hostname
  ).attr('target', '_blank')

  # Offcanvas
  $("[data-toggle=\"offcanvas\"]").click ->
    $(".row-offcanvas").toggleClass "active"
    $(".offcanvas-toggle a").toggleClass "active"
    return

  # PJAX
  #$(document).pjax(selector, [container], options)
  $(document).pjax('[data-pjax] a, a[data-pjax]', '#pjax-container')



@loaders = () ->
  mainLoader()
  surveysReady()


$(document).ready(loaders)
$(document).on('page:load', loaders)
