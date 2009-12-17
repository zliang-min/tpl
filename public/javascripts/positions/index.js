(function() {
  function activePositionCreation() {
    // TODO image srcs; using a js template engine is a good idea for this
    var positionTemplate = $(
      '<div class="position">' +
        '<h3>' +
          '<a href="#" class="icon-link-minimize "><img alt="Minimize" class="icon" src="/images/icons/minimize.png" title="toggle" /></a>' +
          '<span class="info">' +
            '<span class="name"></span>' +
            '-' +
            '<span class="category"></span>' +
            '<span class="state"></span>' +
          '</span>' +
          '<ul class="horizontal">' +
            '<li><a class="icon-link-show "><img alt="Folder_files" class="icon" src="/images/icons/folder_files.png" title="detail infomation" /></a></li>' +
            '<li><a class="icon-link-add "><img alt="Action_add" class="icon" src="/images/icons/action_add.png" title="add a new profile" /></a></li>' +
          '</ul>' +
          '<div class="clear-float"></div>' +
        '</h3>' +
        '<div class="profiles">' +
          '<p class="notice">There are no profiles for this position yet.</p>' +
        '</div>' +
      '</div>'
    ),

    addPosition = function(object) {
      var position = positionTemplate.clone();
      position.find('.name').text(object.name).end().
        find('.category').text(object.category).end().
        find('.state').text(' ( ' + object.state + ' ) ').end().
        find('.icon-link-show').attr('href', object.profiles_link).end().
        find('.icon-link-add').attr('href', object.new_profile_link).end().
        prependTo($('#positions'));
    },

    showPositionForm = function() {
      var form = $('#position-form');
      $('#sidebar ul ul').find('li').eq(0).fadeOut('fast', function() {
        form.fadeIn('fast').find(':text:first').focus();
      });
      return form;
    };

    var cform = $('#category-form').find('form');
    $$._handleFormSubmit(cform, {
      beforeSubmit: function() { cform.mask('Wait...') },
      afterSubmit: function() { cform.unmask() },
      onSuccess: function(data) {
        data = data.category;
        $('<option/>').attr('value', data.id).attr('selected', 'selected').
          text(data.name).appendTo(
            $('#position-form').find('select[name=position[category_id]]')
          );
        cform.find('.cancel').click();
      }
    });

    var pform = $('#position-form').find('form');
    $$._handleFormSubmit(pform, {
      beforeSubmit: function() { pform.mask('Wait...') },
      afterSubmit: function() { pform.unmask() },
      onSuccess: function(data) {
        $('#content > p').remove();
        addPosition(data.position);
        pform.find('.cancel').click();
      }
    });

    $(':input.cancel').click(function(event) {
      event.preventDefault();
      this.form.reset();
      $(this.form).find('select').map(function() {
        // In IE, after reset, $('select').val() is null!
        if(!this.selectedIndex < 0)
          $(this).val(
            $(this.options[this.selectedIndex]).val()
          );
      });
      $(this.form).parent().fadeOut('normal', function() {
        $(this).prev().fadeIn('fast').find(':text:first').focus();
      });
      return false;
    });

    $('#tool-link-add-position,#tool-link-add-position-alt').
      click(function(event) {
        event.preventDefault();
        showPositionForm();
        return false;
    });

    $('.icon-link-add-category').click(function(event) {
      event.preventDefault();
      $('#position-form').fadeOut('fast', function() {
        $('#category-form').fadeIn('fast').find(':text:first').focus();
      });
      return false;
    });
  }

  function activePositionEditor() {
    var updatePosition = function(data) {
      var position = data.position;
      $('#position-' + position.id).find('.info').html(
        '<span class="name">' + position.name + '</span> - ' +
        '<span class="category">' + position.category + '</span>' +
        '<span class="state"> ( ' + position.state + ' )</span>'
      );
    }

    $('.icon-link-edit').click(function(event) {
      event.preventDefault();
      $('#position-edit-form').data('url', $(this).attr('href')).dialog('open');
      return false;
    });

    $('#position-edit-form').bind('dialogopen', function() {
        var self = $(this);
        self.mask('Loading...');
        self.load(self.data('url'), function(text, status, req) {
          if(status != 'success') {
            self.html('<p>Sorry, unknow exception is caught, you may try it later.</p>')
          } else {
            $$._handleFormSubmit(self.find('form'), {
              beforeSubmit: function() { self.mask('Wait...') },
              afterSubmit: function() { self.unmask() },
              onSuccess: function(data) {
                updatePosition(data);
                self.dialog('close');
              }
            });
          }
          self.unmask();
        })
    });
  }

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
    var changeProfileState = function(data) {
      data = data.profile;
      var tds = $('#profile-' + data.id).children('td');
      tds.eq(1).text(data.state);
    };

    $('.event').live('click', function(event) {
      event.preventDefault();
      $('#state-form').find('form').attr('action', this.href).end().dialog('open');
      return false;
    });

    var stateForm = $('#state-form');
    $$._handleFormSubmit(stateForm.find('form'), {
      beforeSubmit: function() { stateForm.mask('Wait...') },
      afterSubmit: function() { stateForm.unmask() },
      onSuccess: function(data) {
        changeProfileState(data);
        stateForm.dialog('close');
      }
    });
  }

  $(function() {
    activePositionCreation();
    activePositionEditor();
    makePositionFoldable();
    setupStateChanging();
  });
})();
