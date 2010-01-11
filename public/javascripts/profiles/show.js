(function() {
  $(function() {
    $$.activeStateChangingDialog({
      link: 'input.event',
      urlAttr: 'data-href',
      onSuccess: function(data) {
        $('#state').text(data.profile.state);
        $('#assignment-info').text(data.profile.assignment_info);
        /* TODO operation log */
      }
    });
  });
})();
