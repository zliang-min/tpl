(function() {
  function makePositionFoldable() {
    $('.icon-link-minimize').live('click', function() {
      var link = $(this);
      link.parent().next().slideUp('fast', function() {
        var img = link.children('img');
        img.attr('src', img.attr('src').replace('minimize', 'maximize'));
        link.removeClass('icon-link-minimize').addClass('icon-link-maximize');
      });
      return false;
    });

    $('.icon-link-maximize').live('click', function() {
      var link = $(this);
      link.parent().next().slideDown('fast', function() {
        var img = link.children('img');
        img.attr('src', img.attr('src').replace('maximize', 'minimize'));
        link.removeClass('icon-link-maximize').addClass('icon-link-minimize');
      });
      return false;
    });
  }

  function setupStateChanging() {
    $$.activeStateChangingDialog({
      link: '.event',
      onSuccess: function(data) {
        data = data.profile;
        $('#profile-' + data.id).children('td').
        eq(1).text(data.state).end().
        eq(2).text(data.assignment_info);
      }
    });
  }

  $(function() {
    makePositionFoldable();
    setupStateChanging();
  });
})();
