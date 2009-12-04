var onLoadCallback = (function() {
  function prepareForms() {
    $('#tool-save').click(function(event) {
      event.preventDefault();
      $('form').submit()
      return false;
    });

    $('form').find(':text:first').focus();
  }

  return function() {
    prepareForms();
  }
})();
