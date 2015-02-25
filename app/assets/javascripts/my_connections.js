$(function() {

  function confirm_validic_sync(link)
  {
    bootbox.confirm("During the enrollment process for CCFA Partners you granted permission for your data to be used for research purposes.  By connecting this app/device you are reconfirming that this data could also be used for research purposes." , function(confirmation) { 
      if( confirmation )
      {
        window.location.href = link;
      }
    });
  }

  function confirm_validic_unsync(link)
  {
    bootbox.confirm("Moving forward with this disconnect action will prevent all future data from this app/device to be shared with CCFA Partners.  Your previously shared information will remain and be used for research purposes.  If you would like all of your previously shared data removed, please contact support at <a href='mailto:support@ccfapartners.org'>info@ccfapartners.org." , function(confirmation) { 
      if( confirmation )
      {
        window.location.href = link;
      }
    });
  }

  //function custom_confirm_validic_sync(link)
  //{
  //  var forward_link = link;
  //  bootbox.dialog({
  //    message: "during the enrollment process for ccfa partners you granted permission for your data to be used for research purposes.  by connecting this app/device you are reconfirming this data could also be used for research purposes",
  //    title: "confirm connect",
  //    buttons: {
  //      ok: {
  //        label: "ok",
  //        classname: "btn-primary",
  //        callback: function() {
  //          //document.location.assign(forward_link);
  //          window.location.href = forward_link;
  //        }
  //      },
  //      cancel: {
  //        label: "cancel",
  //        classname: "btn-default",
  //        callback: function(link) {
  //          return true;
  //        }
  //      }
  //    }
  //  });
  //}

    $(".sync_link").click( function(e) {
      //bootbox.alert("bootbox hello");
      confirm_validic_sync($(this).attr('href'));
      return false;
    });
    $(".unsync_link").click( function(e) {
      confirm_validic_unsync($(this).attr('href'));
      return false;
    });

  });