(function() {
  function setupStateChanging() {
    $$.activeStateChangingDialog({
      link: '#profile-table .event',
      onSuccess: function(data) {
        data = data.profile;
        $('#profile-' + data.id).children('td').
        eq(1).text(data.state).end().
        eq(2).text(data.assignment_info);
      }
    });
  }

  function enablePositionClosing() {
    $('#link-close-position').click(function(event) {
      event.preventDefault();
      if(confirm('Are you sure?')) {
        $.post($(this).attr('href'), {'_method':'DELETE'}, function(data, status) {
          if(status == 'success') {
            window.location.replace(data.redirect_to)
          } else {
            alert($$.exceptionMsg)
          }
        }, 'json');
      }
      return false;
    });
  }

  $(function() {
    enablePositionClosing();
    setupStateChanging();
  });
})();
