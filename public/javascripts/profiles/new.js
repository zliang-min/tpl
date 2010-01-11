(function() {
  function prepareForm() {
    var form = $('#profile_form');

    $('#tool-save').click(function(event) {
      event.preventDefault();
      form.submit()
      return false;
    });

    $('#btn-add-resume').click(function(event) {
      event.preventDefault();
      var resumes = $('.resume_field'),
              num = resumes.size(),
          lastOne = resumes.eq(num - 1);
      $('<input/>').attr('type', 'file').attr('id', 'profile_resumes_' + num + '_file').attr('name', 'profile[resumes][' + num + '][file]').attr('size', lastOne.find('input').attr('size')).appendTo(
        $('<div/>').addClass('resume_field').insertAfter(lastOne)
      );
    });

    form.find(':text:first').focus();
  }

  $(prepareForm);
})();
