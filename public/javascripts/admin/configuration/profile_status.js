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

  function enableAddMoreButton() {
    $('#add_status').click(function() {
      var container = $('#statuses');
      // we start from 0
      $(statusTemplate(container.find('div').size())).appendTo(container);
      container.find('input:last').focus();
    });
  }

  return function() {
    enableAddMoreButton();
  };
})();
