var onLoadCallback = (function() {
// ********* loadmask ************
/**
 * Copyright (c) 2009 Sergiy Kovalchuk (serg472@gmail.com)
 * 
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
 *  
 * Following code is based on Element.mask() implementation from ExtJS framework (http://extjs.com/)
 *
 */
function enableLoadmask($){
	
	/**
	 * Displays loading mask over selected element.
	 *
	 * @param label Text message that will be displayed on the top of a mask besides a spinner (optional). 
	 * 				If not provided only mask will be displayed without a label or a spinner.  	
	 */
	$.fn.mask = function(label){
		
		this.unmask();
		
		if(this.css("position") == "static") {
			this.addClass("masked-relative");
		}
		
		this.addClass("masked");
		
		var maskDiv = $('<div class="loadmask"></div>');
		
		//auto height fix for IE
		if(navigator.userAgent.toLowerCase().indexOf("msie") > -1){
			maskDiv.height(this.height() + parseInt(this.css("padding-top")) + parseInt(this.css("padding-bottom")));
			maskDiv.width(this.width() + parseInt(this.css("padding-left")) + parseInt(this.css("padding-right")));
		}
		
		//fix for z-index bug with selects in IE6
		if(navigator.userAgent.toLowerCase().indexOf("msie 6") > -1){
			this.find("select").addClass("masked-hidden");
		}
		
		this.append(maskDiv);
		
		if(typeof label == "string") {
			var maskMsgDiv = $('<div class="loadmask-msg" style="display:none;"></div>');
			maskMsgDiv.append('<div>' + label + '</div>');
			this.append(maskMsgDiv);
			
			//calculate center position
			maskMsgDiv.css("top", Math.round(this.height() / 2 - (maskMsgDiv.height() - parseInt(maskMsgDiv.css("padding-top")) - parseInt(maskMsgDiv.css("padding-bottom"))) / 2)+"px");
			maskMsgDiv.css("left", Math.round(this.width() / 2 - (maskMsgDiv.width() - parseInt(maskMsgDiv.css("padding-left")) - parseInt(maskMsgDiv.css("padding-right"))) / 2)+"px");
			
			maskMsgDiv.show();
		}
		
	};
	
	/**
	 * Removes mask from the element.
	 */
	$.fn.unmask = function(label){
		this.find(".loadmask-msg,.loadmask").remove();
		this.removeClass("masked");
		this.removeClass("masked-relative");
		this.find("select").removeClass("masked-hidden");
	};
 
}
// ********* end loadmask ************

  function enableDialogs() {
    $('.dialog').dialog({
      autoOpen: false,
      buttons: {
        Cancel: function() { $(this).dialog('close') },
        OK: submitForm
      },
      open: function() {
        var form = $(this).find('form').get(0);
        if(form) form.reset()
      }
    }).each(function() {
      var d = $(this);
      d.dialog('option', 'title', d.attr('data-dialog-title')).
      dialog('option', 'height', parseInt(d.attr('data-dialog-height'))).
      dialog('option', 'width', parseInt(d.attr('data-dialog-width'))).
      dialog('option', 'modal', d.hasClass('modal')).
      dialog('option', 'resizable', !d.hasClass('not-resizable'));
    });
  }

  function submitForm() {
    $(this).find('form').submit()
  }

  function _handleFormSubmit(form, options) {
    form.submit(function(event) {
      event.preventDefault();
      $.ajax({
        type: 'POST',
        url: this.action + '.json',
        dataType: 'json',
        data: $(this).serialize(),
        success: options.onSuccess,
        error: function(req, text) { alert(errorMsg(req)) }
      });
      return false;
    });
  }

  // TODO this can be a global function
  function errorMsg(req) {
    try {
      // error format: [['field_name#1', 'error message#1'], ... , ['field_name#N', 'error message#N']]
      var error = eval('(' + req.responseText + ')');
    } catch(e) {
      var error = []
    }
    var msg = [];
    $.each(error, function() {
      msg.push(this.join(' '))
    });
    if( msg.length < 1 ) msg.push('Opps! Error occured. You may try it later.')
    return msg.join("\n");
  }

  function prepareForms() {
    var cform = $('#category-form').find('form');
    _handleFormSubmit(cform, {
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
    _handleFormSubmit(pform, {
      onSuccess: function(data) {
        $('#content > p').remove();
        addPosition(data.position);
        pform.find('.cancel').click();
      }
    });

    _handleFormSubmit($('#state-form').find('form'), {
      onSuccess: function(data) {
        changeProfileState(data);
        $('#state-form').dialog('close');
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
  }

  var positionTemplate;
  function prepareTemplate() {
    // TODO image srcs; Is putting this template on the view and grabbing it here a better idea?
    positionTemplate = $(
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
    );
  }

  function addPosition(object) {
    var position = positionTemplate.clone();
    position.find('.name').text(object.name).end().
      find('.category').text(object.category).end().
      find('.state').text(' ( ' + object.state + ' ) ').end().
      find('.icon-link-show').attr('href', object.profiles_link).end().
      find('.icon-link-add').attr('href', object.new_profile_link).end().
      prependTo($('#positions'));
  }

  function updatePosition(data) {
    var position = data.position;
    $('#position-' + position.id).find('.info').html(
      '<span class="name">' + position.name + '</span> - ' +
      '<span class="category">' + position.category + '</span>' +
      '<span class="state"> ( ' + position.state + ' )</span>'
    );
  }

  function showPositionForm() {
    var form = $('#position-form');
    $('#sidebar ul ul').find('li').eq(0).fadeOut('fast', function() {
      form.fadeIn('fast').find(':text:first').focus();
    });
    return form;
  }

  function activeLinks() {
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

    $('.event').live('click', function(event) {
      event.preventDefault();
      $('#state-form').find('form').attr('action', this.href).end().dialog('open');
      return false;
    });

    $('.icon-link-edit').click(function(event) {
      event.preventDefault();
      $('#position-edit-form').data('url', $(this).attr('href')).dialog('open');
      return false;
    });
  }

  function changeProfileState(data) {
    data = data.profile;
    var tds = $('#profile-' + data.id).children('td');
    tds.eq(1).text(data.state);
  }

  function preparePositionEditDialog() {
    $('#position-edit-form').bind('dialogopen', function() {
        var self = $(this);
        self.mask('Loading...');
        self.load(self.data('url'), function(text, status, req) {
          if(status != 'success') {
            self.html('<p>Sorry, unknow exception is caught, you may try it later.</p>')
          } else {
            _handleFormSubmit(self.find('form'), {
              onSuccess: function(data) {
                updatePosition(data);
                $('#position-edit-form').dialog('close');
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

  return function() {
    enableDialogs();
    preparePositionEditDialog();
    prepareForms();
    activeLinks();
    prepareTemplate();
    enableLoadmask(jQuery);
    makePositionFoldable();
  }
})();
