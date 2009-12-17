(function() {
  function activeAppointmentSwitch() {
    $('#appointment-switch').click(function() {
      if($(this).hasClass('on'))
        $('.appointment-fields').hide();
      else
        $('.appointment-fields').show();
      $(this).toggleClass('on');
    })

    $('#state-form').bind('dialogopen', function() {
      $('#appointment-switch').val(false).removeClass('on');
      $('.appointment-fields').hide();
    });
  }

  $(activeAppointmentSwitch);
})();
