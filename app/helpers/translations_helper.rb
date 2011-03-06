# Methods added to this helper will be available to all templates in the application.
module TranslationsHelper
  def include_i18n_editor
    return nil if not ENV['I18N_EDITOR']I18N_PATCH == true
    javascript = "
      // i18n locale editor
      // =================
      // - lazy loads jQuery from jQuery's CDN if it is not defined and declares it as $j if $js is undefined
      // - waits for jQuery initialization and then lazy-loads itself
      // - it expect i18n-locale-editor.js in /public/javascripts
      
      i18n_locale = '#{I18n.locale.to_s}';

      if(typeof($j) === 'undefined'){
        var $j;
      }

      function i18n_lazy_load_js(url){
        var s = document.createElement('script');
        s.type = 'text/javascript';
        s.async = true;
        s.src = url;
        var x = document.getElementsByTagName('script')[0];
        x.parentNode.insertBefore(s, x);
      }

      function i18n_lazy_loader(){
        if(! (typeof(jQuery) === 'function')){
          i18n_lazy_load_js('http://code.jquery.com/jquery-1.5.1.min.js')
        }
        interval = setInterval(function(){
          if(typeof(jQuery) === 'function'){
            if(typeof($j) === 'undefined'){
              $j = jQuery.noConflict();
            }
            i18n_lazy_load_js('/javascripts/i18n-locale-editor.js')
            clearInterval(interval);
          }
        },100)

      }

      if(window.attachEvent) {
        window.attachEvent('onload', i18n_lazy_loader);
      } else {
        window.addEventListener('load', i18n_lazy_loader, false);
      }

      "
      javascript_tag javascript
    end
  end
ActionView::Base.send :include, TranslationsHelper