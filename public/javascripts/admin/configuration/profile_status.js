var onLoadCallback = (function() {
  function statusTemplate(num) {
    var template =
      '<div>' +
        '<input type="text" name="ProfileStatus[statuses][' +
        num +
        ']" id="ProfileStatus_statuses_' +
        num +
        '"></input>' +
      '</div>';
    return template;
  }

  function addAStateTextField() {
    var container = $('#statuses');
    // we start from 0
    $(statusTemplate(container.find('div').size())).appendTo(container);
    var newlyAdded = container.find('input:last');
    newlyAdded.focus();
    return newlyAdded;
  }

  function enableAddMoreButton() {
    $('#add_status').click(function() {
      addAStateTextField();
    });
  }

  function enableClickableLabels() {
    $('label.state').dblclick(function() {
      addAStateTextField().val($(this).text());
    });
  }

  return function() {
    enableAddMoreButton();
    enableClickableLabels();
  };
})();
