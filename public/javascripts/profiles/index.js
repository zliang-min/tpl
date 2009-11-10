var onLoadCallback = (function() {
  function enableDialogs() {
    $('.dialog').dialog({
      autoOpen: false,
      buttons: {
        Create: submitForm,
        Cancel: function() { $(this).dialog('close') }
      }
    }).each(function() {
      var d = $(this);
      d.dialog('option', 'title', d.attr('data-dialog-title')).
      dialog('option', 'width', d.attr('data-dialog-width')).
      dialog('option', 'height', d.attr('data-dialog-height')).
      dialog('option', 'modal', d.hasClass('modal'));
    });

    $('.dialog-switch').click(function(event) {
      event.preventDefault();
      $('#' + $(this).attr('data-dialog')).dialog('open');
      return false;
    });
  }

  function submitForm() {
    $(this).find('form').submit()
  }

  function _handleFormSubmit(form, options) {
    form.submit(function(event) {
      event.preventDefault();
      $.ajax({
        type: 'POST',
        url: this.action + '.json',
        dataType: 'json',
        data: $(this).serialize(),
        success: options.onSuccess,
        error: ( options.onError || function(req, text) { alert(errorMsg(req)) } )
      });
      return false;
    });
  }

  // TODO this can be a global function
  function errorMsg(req) {
    try {
      // error format: [['field_name#1', 'error message#1'], ... , ['field_name#N', 'error message#N']]
      var error = eval('(' + req.responseText + ')');
    } catch(e) {
      var error = []
    }
    var msg = [];
    $.each(error, function() {
      msg.push(this.join(' '))
    });
    msg = msg.join("\n");
    if( msg == '' ) msg = "Error occured. Please try it later.";
    return msg;
  }

  function handleFormSubmit() {
    _handleFormSubmit($('#profile-form').find('form'), {
      onSuccess: function(data) {
        $('p.notice').remove();
        addProfile(data.profile);
        $('#profile-form').dialog('close');
      }
    });

    _handleFormSubmit($('#feedback-form').find('form'), {
      onSuccess: function(data) {
        changeProfileEvent(data);
        $('#feedback-form').dialog('close');
      },
      onError: function(req, text) { alert("Sorry, operation failed. Please try it later.") }
    });
  }

  function addProfile(object) {
    var tr = $('<tr/>').attr('id', 'profile-' + object.id);
    $('<a/>').attr('href', object.show_link).text(object.name).
      appendTo( $('<td/>').appendTo(tr) );
    $('<td/>').text(object.state).appendTo(tr);
    createProfileEventLinks( $('<td/>').appendTo(tr), object.events );
    tr.appendTo($('#profile-table').find('tbody'));
  }

  function createProfileEventLinks(td, events) {
    td = $(td);
    if( td.is(':has(ul)') ) {
      ul = td.children('ul');
      ul.children().remove();
    } else {
      ul = $('<ul/>').appendTo(td);
    }

    $.each(events, function() {
      $('<a/>').addClass('event').attr('href', this.url).
        text(this.name).appendTo(
          $('<li/>').appendTo(ul)
        );
    });
  }

  function setupTable() {
    $('tbody tr').live('hover',
        function() { $(this).addClass('hover') },
        function() { $(this).removeClass('hover') }
    );

    $('#profile-table .event').live('click', function(event) {
      event.preventDefault();
      $('#feedback-form').find('form').attr('action', this.href).end().dialog('open');
      return false;
    });
  }

  function changeProfileEvent(data) {
    data = data.profile;
    var tds = $('#profile-' + data.id).children('td');
    tds.eq(1).text(data.state).end();
    createProfileEventLinks(tds.eq(2), data.events);
  }

  return function() {
    enableDialogs();
    handleFormSubmit();
    setupTable();
  }
})();
