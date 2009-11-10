var onLoadCallback = (function() {
  function prepareForms() {
    var fakeForm = $('#fake-form');
    var realForm = $('#real-form');

    // fake form never submits.
    fakeForm.submit(function(event) {
      event.preventDefault(); return false;
    });

    // copy values from fake form to real form
    $('.copy-cat').each(function() {
      var cat = $(this);
      fakeForm.find('#' + this.id).change(function() {
        // Is it a good idea that let two elements have the same id?
        // But if names are used here, a textarea with the same name cannot be found! Don't know why.
        cat.val( $(this).val() );
      });
    });

    // links
    $('#tool-save').click(function(event) {
      event.preventDefault();
      realForm.submit();
      return false;
    });
  }

  return function() {
    prepareForms();
  }
})();
