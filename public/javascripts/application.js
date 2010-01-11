(function($) {
  var window = this,
      nurun  = window.nurun = window.$$ = {};

  $.extend(nurun, {
    exceptionMsg: "Sorry, unknow exception is caught, you may try it later.",

    _handleFormSubmit: function(form, options) {
      form.submit(function(event) {
        event.preventDefault();
        if(options.beforeSubmit) options.beforeSubmit();
        var submit = $(this).find(':submit').attr('disabled', 'disabled');
        $.ajax({
          type: 'POST',
          url: this.action + '.json',
          dataType: 'json',
          data: $(this).serialize(),
          success: function() {
            options.onSuccess.apply(this, arguments);
            submit.attr('disabled', null);
            if(options.afterSubmit) options.afterSubmit();
          },
          error: function() {
            var handler = options.onError || nurun.showErrorMsg;
            handler.apply(this, arguments);
            submit.attr('disabled', null);
            if(options.afterSubmit) options.afterSubmit();
          }
        });
        return false;
      });
    },

    showErrorMsg: function(req, text) {
      alert(nurun.errorMsg(req))
    },

    errorMsg: function(req) {
      try {
        /* error format: [['field_name#1', 'error message#1'], ... , ['field_name#N', 'error message#N']] */
        var error = eval('(' + req.responseText + ')');
      } catch(e) {
        var error = []
      }
      var msg = [];
      $.each(error, function() {
        msg.push(this.join(' '))
      });
      if( msg.length < 1 ) msg.push(this.exceptionMsg)
      return msg.join("\n");
    }
  }); /* end $.extend */

  if($.fn.dialog) {
    $.extend(nurun, {
      enableDialogs: function() {
        $('.dialog').dialog({
          autoOpen: false,
          buttons: {
            Cancel: function() {$(this).dialog('close') },
            OK: function() {
              var self = $(this);
              if(self.data('okable')) {
                self.data('okable', false);
                self.find('form').submit();
              }
            }
          },
          open: function() {
            $(this).data('okable', true);
            var form = $(this).find('form').get(0);
            if(form) form.reset()
          }
        }).each(function() {
          var d = $(this);
          d.dialog('option', 'title', d.attr('data-dialog-title')).
          dialog('option', 'height', parseInt(d.attr('data-dialog-height'))).
          dialog('option', 'width', parseInt(d.attr('data-dialog-width'))).
          dialog('option', 'modal', d.hasClass('modal')).
          dialog('option', 'resizable', !d.hasClass('not-resizable'));
        });
      }
    });

    $(nurun.enableDialogs);
  }
})(jQuery);
