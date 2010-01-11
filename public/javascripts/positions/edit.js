(function() {
  var submitForm = {target: null};

  function initSubmitForm() { submitForm.target = $('#position_form') }

  function enableCategoryCreation() {
    var pf = $('#position_form'),
        cf = $('#new_category');

    function hideCategoryForm() {
      cf.fadeOut('fast', function() {
        pf.fadeIn('fast', function() {
          submitForm.target = pf;
        });
      });
    }

    function showCategoryForm() {
      pf.fadeOut('fast', function() {
        cf.fadeIn('fast', function() {
          submitForm.target = cf;
          $('#tool-cancel').one('click', function(event) {
            event.preventDefault();
            hideCategoryForm();
          }); /* one */
        }); /* fadeIn */
      }); /* fadeOut */
    }

    $('.icon-link-add-category').click(function(event) {
      event.preventDefault();
      showCategoryForm();
    });

    $$._handleFormSubmit(cf, {
      beforeSubmit: function() {
        $('#page').mask('Wait...')
      },
      afterSubmit: function() {
        $('#page').unmask()
      },
      onSuccess: function(data) {
        data = data.category;
        $('<option/>').attr('value', data.id).attr('selected', 'selected').
          text(data.name).appendTo(
            pf.find('select[name=position[category_id]]')
          );
        $('#tool-cancel').click()
      }
    });
  }

  function prepareForm() {
    $('#tool-save').click(function(event) {
      event.preventDefault();
      submitForm.target.submit()
      return false;
    });

    $('#position_form').find(':text:first').focus();
  }

  $(function() {
    initSubmitForm();
    enableCategoryCreation();
    prepareForm();
  });
})();
