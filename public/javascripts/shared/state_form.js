(function() {
  $.extend($$, {
    activeStateChangingDialog: function(options) {
      var dialog = $('#state-form'),
          urlAttr = options.urlAttr || 'href';
      var openDialog = function(event) {
        event.preventDefault();
        var self = $(this),
            form = dialog.find('form').attr('action', self.attr(urlAttr)),
            state = self.attr('data-state'),
            assigned_to = self.attr('data-assigned_to');

        dialog.dialog('open');

        /* form will be reset when the dialog opens, so these have to be done after open */
        if(state) form.find('#profile_state').val(state);
        if(assigned_to) form.find('#profile_assign_to').val(assigned_to);

        return false;
      };

      if(options.live)
        $(options.link).live('click', openDialog);
      else
        $(options.link).click(openDialog);

      this._handleFormSubmit(dialog.find('form'), {
        beforeSubmit: function() { dialog.mask('Wait...') },
        afterSubmit: function() { dialog.unmask() },
        onSuccess: function(data) {
          options.onSuccess(data);
          dialog.dialog('close');
        }
      });

      activeAppointmentSwitch();
    }
  });

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
})();
