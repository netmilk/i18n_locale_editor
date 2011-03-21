if(typeof $j === 'undefined'){
  $j = jQuery.noConflict();
}

function attach_callbacks() { 
  $j('.i18n-translation').each(function(){
    $j(this).bind('click.i18n_selector',function(event){
      event.preventDefault();
      fill_modal($j(this));
      show_modal();
      return false;
    }).bind('mouseover.i18n_selector',
       function(){
      $j(this).addClass('i18n-highlighted')
      $j('#i18n-text').html($j(this).attr('id'))
    }).bind('mouseout.i18n_selector', function(){
      $j(this).removeClass('i18n-highlighted')
      $j('#i18n-text').html('none')
    })
    red_button();                                
  })

}

function detach_callbacks() {
  $j('.i18n-translation').unbind('click.i18n_selector').unbind('mouseover.i18n_selector').unbind('mouseout.i18n_selector');
  $j('#i18n-button').css('background-color', 'blue');
  blue_button();
}
 
function blue_button() {
  $j('#i18n-button').bind('click.i18n_attach_callbacks',function(){
    attach_callbacks();
    return false;
  }).html('SELECT')
}

function red_button(){
  $j('#i18n-button').css('background-color', 'red').html('STOP')
  $j('#i18n-button').unbind('click.i18n_attach_callbacks')
  $j('#i18n-button').bind('click.i18n_detach_callbacks',function(){
    detach_callbacks();
    return false;
  })

}

function hide_modal(){
  $j('#i18n-mask, .i18n-window').hide();
}

function fill_modal(element){
  url = "/translations/index"
  content = '\
  <input type="hidden" name="i18n-form-key" value="'+element.attr('id')+'" id="i18n-form-key">\
  <form onsubmit="i18n_send_form();return false;">\
  <textarea name="i8n-form-value" id="i18n-form-value">'+element.html()+'</textarea>\
  </form>\
  <div><a href="#" id="i18n-commit">commit change</a></div\
  <div><a href="#" id="i18n-toggle-wymeditor" style="display: none">toggle wymeditor</a></div\
  <div><a href="'+url+'#'+ element.attr('id') +'" target="_blank">open in translation editor</a></div>\
  '
  $j('#18n-modal-content').html(content);
  
  //$j('#i18n-toggle-wymeditor').click(function(){
  //  $j('#i18n-form-value').wymeditor({
  //      updateSelector: "#i18n-commit"
  //  });
  //})

  $j('#i18n-commit').click(function(){
    i18n_send_form();
  })
}

function i18n_send_form(){
  key = $j('#i18n-form-key').val();
  value = $j('#i18n-form-value').val();
  selector = 'span[id="'+key+'"]';
  $j(selector).html(value);
  update_value(key, value)
  hide_modal();
}

function update_value(key,value) {
  $j('span[id="'+key+'"]').siblings(".i18n-highlighted-exclamation").hide()
  $j('#i18n-working').show()
  url= '/translations/set_value/'+key
  request = $j.ajax({
    // GET method to be able pass redirects
    type: 'GET',
    url: url,
    data: {value: value},
    async: true,
    success: function(){
      $j('#i18n-working').hide();

      },
    error: function(){
      alert('error posting data to url:'+url);
      $j('#i18n-working').hide()
    }
  })
}
function show_modal(){
        element = $j("#i18n-dialog");
        var maskHeight = $j(document).height();
        var maskWidth = $j(window).width();
        $j('#i18n-mask').css({'width':maskWidth,'height':maskHeight});
        $j('#i18n-mask').show();   
        var winH = $j(window).height();
        var winW = $j(window).width();
        element.css('top',  winH/2-element.height()/2);
        element.css('left', winW/2-element.width()/2);
        element.show()
}

function i18n_initialize_selectors() {
  add_assets();
  $j("#i18n-button").show()
  blue_button();
  $j('#i18n-modal-close').click(function(){
    hide_modal();
  })
}

function i18n_initialize_editor(){
  add_assets();      
  $j('.i18n-translation-cell').click(function(){
    fill_modal($j('.i18n-translation', this));
    show_modal();
  }).hover(function(){
      $j(this).addClass('i18n-highlighted-cell');
    }, function(){
      $j(this).removeClass('i18n-highlighted-cell');
    }
  )
}

function add_assets() {
  $j('\
  <div id= "i18n-placeholder" >\
    <div id="i18n-text">&nbsp;</div>\
    <a id="i18n-button" href="#" style="display: none">&nbsp;</a>\
    <div id="i18n-working" style="display: none">Zzz...</div>\
  </div>\
  \
  <div id="i18n-boxes">\
    <div id="i18n-dialog" class="i18n-window">\
      <div id="18n-modal-content"></div>\
      <a href="#" id="i18n-modal-close" onclick="hide_modal();return false;">close window</a>\
    </div>\
    <div id="i18n-mask"></div>\
  </div>\
  ').appendTo("body")
  $j('\
  <style type="text/css">  \
    .i18n-highlighted{ cursor: default; outline: 3px solid yellow}  \
    #i18n-text{ text-align: right; }\
    #i18n-working{ text-align: center;line-height: 30px;width: 50px; height: 30px; float: right; background-color: #444; color: white;}\
    #i18n-button{ text-align: center;line-height: 30px;width: 50px; height: 30px; float: right; background-color: #111; color: white;}\
    #i18n-button a{ color: white;}\
    #i18n-button a:hover{ color: white;}\
    #i18n-placeholder{font-size: 12px;font-family: Verdana, Arial, sans-serif; margin:auto;  position: fixed; z-index: 10000; right: 0px; bottom: 0px;}\
    #i18n-mask { position:absolute; top: 0; z-index:9998; background-color:#000; display:none;opacity:0.4;filter:alpha(opacity=40) } \
    #i18n-boxes .i18n-window { font-size: 12px;font-family: Verdana, Arial, sans-serif;position:fixed;width:600px;height:400px;display:none;z-index:9999;padding:20px;} \
    #i18n-boxes #i18n-dialog { width:580px; height:400px; background-color: white; }\
    #i18n-boxes #i18n-dialog textarea { width:560px; height:300px; background-color: white; }\
  </style> \
  ').appendTo("head");
}

if(! ($j('.i18n-translation-editor').length == 0)){
  i18n_initialize_editor();
} else{
  i18n_initialize_selectors();
}

