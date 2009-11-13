var onLoadCallback = (function() {
  function enableDialogs() {
    $('.dialog').dialog({
      autoOpen: false,
      buttons: {
        Cancel: function() { $(this).dialog('close') },
        OK: submitForm
      },
      open: function() { $(this).find('form').get(0).reset() }
    }).each(function() {
      var d = $(this);
      d.dialog('option', 'title', d.attr('data-dialog-title')).
      dialog('option', 'height', parseInt(d.attr('data-dialog-height'))).
      dialog('option', 'width', parseInt(d.attr('data-dialog-width'))).
      dialog('option', 'modal', d.hasClass('modal')).
      dialog('option', 'resizable', !d.hasClass('not-resizable'));
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

  function prepareForms() {
    var cform = $('#category-form').find('form');
    _handleFormSubmit(cform, {
      onSuccess: function(data) {
        data = data.category;
        $('<option/>').attr('value', data.id).attr('selected', 'selected').
          text(data.name).appendTo(
            $('#position-form').find('select[name=position[category_id]]')
          );
        cform.find('.cancel').click();
      }
    });

    var pform = $('#position-form').find('form');
    _handleFormSubmit(pform, {
      onSuccess: function(data) {
        $('#positions > p').remove();
        addPosition(data.position);
        pform.find('.cancel').click();
      }
    });

    $(':input.cancel').click(function(event) {
      event.preventDefault();
      this.form.reset();
      $(this.form).parent().fadeOut('normal', function() {
        $(this).prev().fadeIn('fast').find(':text:first').focus();
      });
      return false;
    });
  }

  var positionTemplate;
  function prepareTemplate() {
    // TODO image srcs; Is putting this template on the view and grabbing it here a better idea?
    positionTemplate = $(
      '<div class="position">' +
        '<h3>' +
          '<a href="#" class="icon-link-minimize "><img alt="Minimize" class="icon" src="/images/icons/minimize.png" title="toggle" /></a>' +
          '<span class="info">' +
            '<span class="name"></span>' +
            '-' +
            '<span class="category"></span>' +
            '<span class="state"></span>' +
          '</span>' +
          '<ul class="horizontal">' +
            '<li><a class="icon-link-show "><img alt="Folder_files" class="icon" src="/images/icons/folder_files.png" title="detail infomation" /></a></li>' +
            '<li><a class="icon-link-add "><img alt="Action_add" class="icon" src="/images/icons/action_add.png" title="add a new profile" /></a></li>' +
          '</ul>' +
          '<div class="clear-float"></div>' +
        '</h3>' +
        '<div class="profiles">' +
          '<p class="notice">There are no profiles for this position yet.</p>' +
        '</div>' +
      '</div>'
    );
  }

  function addPosition(object) {
    var position = positionTemplate.clone();
    position.find('.name').text(object.name).end().
      find('.category').text(object.category).end().
      find('.state').text(object.state).end().
      find('.icon-link-show').attr('href', object.profiles_link).end().
      find('.icon-link-add').attr('href', object.new_profile_link).end().
      prependTo($('#positions'));
  }

  function activeLinks() {
    $('#tool-link-add-position').click(function(event) {
      event.preventDefault();
      $(this).parent('li').fadeOut('fast', function() {
        $('#position-form').fadeIn('fast').find(':text:first').focus();
      });
      return false;
    });
    $('#tool-link-add-position-alt').click(function(event) {
      event.preventDefault();
      $('#tool-link-add-position').click();
      return false;
    });

    $('.icon-link-add-category').click(function(event) {
      event.preventDefault();
      $('#position-form').fadeOut('fast', function() {
        $('#category-form').fadeIn('fast').find(':text:first').focus();
      });
      return false;
    });

    $('.event').click(function(event) {
      event.preventDefault();
      $('#feedback-form').find('form').attr('action', this.href).end().dialog('open');
      return false;
    });
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

  function changeProfileEvent(data) {
    data = data.profile;
    var tds = $('#profile-' + data.id).children('td');
    tds.eq(1).text(data.state).end();
    createProfileEventLinks(tds.eq(2), data.events);
  }

  return function() {
    enableDialogs();
    prepareForms();
    activeLinks();
    prepareTemplate();
  }
})();
