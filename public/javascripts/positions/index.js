var onLoadCallback = (function() {
  function enableDialogs() {
    $('.dialog').dialog({
      autoOpen: false,
      buttons: {
        Create: submitForm,
        Cancel: function() { $(this).dialog('close') }
      },
      open: function() { $(this).find('form').get(0).reset() }
    }).each(function() {
      var d = $(this);
      d.dialog('option', 'title', d.attr('data-dialog-title')).
      dialog('option', 'height', d.attr('data-dialog-height')).
      dialog('option', 'width', d.attr('data-dialog-width')).
      dialog('option', 'modal', d.hasClass('modal'));
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
        error: function(req, text) { alert(errorMsg(req)) }
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
    return msg.join("\n");
  }

  function handleFormSubmit() {
    _handleFormSubmit($('#category-form').find('form'), {
      onSuccess: function(data) {
        data = data.category;
        $('<option/>').attr('value', data.id).attr('selected', 'selected').
          text(data.name).appendTo(
            $('#position-form').find('select[name=position[category]]')
          );
        $('#category-form').dialog('close');
      }
    });
    _handleFormSubmit($('#position-form').find('form'), {
      onSuccess: function(data) {
        $('p.notice').remove();
        addPosition(data.position);
        $('#position-form').dialog('close');
      }
    });
  }

  function activeLinks() {
    $.each(['position', 'category'], function() {
      var name = this;
      $('a.button-link-add-' + name).click(function(event) {
        event.preventDefault();
        $('#' + name + '-form').dialog('open');
        return false;
      });
    });
  }

  function addPosition(object) {
    var tr = $('<tr/>');
    $('<td/>').text(object.category.name).appendTo(tr);
    $('<td/>').text(object.name).appendTo(tr);
    $('<td/>').text(object.description).appendTo(tr);
    $('<td/>').text(object.state).appendTo(tr);
    $('<a/>').attr('href', object.profiles_link).text('profiles').appendTo(
      $('<td/>').appendTo(tr)
    );
    tr.appendTo($('#position-table').find('tbody'));
  }

  return function() {
    enableDialogs();
    handleFormSubmit();
    activeLinks();
  }
})();
