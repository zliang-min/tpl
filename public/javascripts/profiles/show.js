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
    $(this).find('form').submit();
  }

  function activeButtons() {
    $('input.event').click(function() {
      $('#feedback-form').find('form').
        attr('action', $(this).attr('data-href')).end().
        dialog('open');
    });
  }

  return function() {
    enableDialogs();
    activeButtons();
  }
})();
