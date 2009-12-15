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
        OK: function() { $(this).find('form').submit() }
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

    $('.dialog-switch').click(function(event) {
      event.preventDefault();
      $('#' + $(this).attr('data-dialog')).dialog('open');
      return false;
    });
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
        error: ( options.onError || function(req, text) { alert(errorMsg(req)) } )
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
    msg = msg.join("\n");
    if( msg == '' ) msg = "Error occured. Please try it later.";
    return msg;
  }

  function handleFormSubmit() {
    _handleFormSubmit($('#profile-form').find('form'), {
      onSuccess: function(data) {
        $('p.notice').remove();
        addProfile(data.profile);
        $('#profile-form').dialog('close');
      }
    });

    _handleFormSubmit($('#state-form').find('form'), {
      onSuccess: function(data) {
        changeProfileState(data);
        $('#state-form').dialog('close');
      },
      onError: function(req, text) { alert("Sorry, operation failed. Please try it later.") }
    });
  }

  function addProfile(object) {
    var tr = $('<tr/>').attr('id', 'profile-' + object.id);
    $('<a/>').attr('href', object.show_link).text(object.name).
      appendTo( $('<td/>').appendTo(tr) );
    $('<td/>').text(object.state).appendTo(tr);
    $('<a/>').addClass('event').attr('href', object.change_state.href).
      text(object.change_state.text).appendTo($('<td/>').appendTo(tr));
    $('<td/>').text(object.chage_state.text).
    tr.appendTo($('#profile-table').find('tbody'));
  }

  function changeProfileState(data) {
    data = data.profile;
    var tds = $('#profile-' + data.id).children('td');
    tds.eq(1).text(data.state);
  }

  function setupTable() {
    $('#profile-table .event').live('click', function(event) {
      event.preventDefault();
      $('#state-form').find('form').attr('action', this.href).end().dialog('open');
      return false;
    });
  }

  function enableEditPosition() {
    var updatePosition = function(data) {
      var position = data.position;
      var dom = $('.position');
      dom.
        find('h2 span').html('Position: ' + position.name).end().
        find('ul li').eq(0).html('Category: ' + position.category).end().
        eq(1).html('State: ' + position.state).end().end().
        find('pre').remove();
      if(position.description)
        $('<pre/>').html(position.description).appendTo(dom);
    }

    // loading
    $('#position-edit-form').bind('dialogopen', function() {
        var self = $(this);
        self.mask('Loading...');
        self.load(self.data('url'), function(text, status, req) {
          if(status != 'success') {
            self.html('<p>Sorry, unknown exception is caught, you may try it later.</p>')
            self.dialog('close');
          } else {
            _handleFormSubmit(self.find('form'), {
              onSuccess: function(data) {
                updatePosition(data);
                self.dialog('close')
              }
            });
          }
          self.unmask();
        })
    });

    // link
    $('.icon-link-edit-position').click(function(event) {
      event.preventDefault();
      $('#position-edit-form').data('url', $(this).attr('href')).dialog('open');
      return false;
    });
  }

  function enableClosePosition() {
    $('#link-close-position').click(function(event) {
      event.preventDefault();
      if(confirm('Are you sure?')) {
        $.post($(this).attr('href'), {'_method':'DELETE'}, function(data, status) {
          if(status == 'success') {
            window.location.replace(data.redirect_to)
          } else {
            alert('Sorry, unknown exception is caught, you may try it later.')
          }
        }, 'json');
      }
      return false;
    });
  }

  return function() {
    enableDialogs();
    enableLoadmask(jQuery);
    handleFormSubmit();
    setupTable();
    enableEditPosition();
    enableClosePosition();
  }
})();
