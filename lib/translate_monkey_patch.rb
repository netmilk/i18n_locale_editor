# Don't run in production, it may cause death or serios injury to your layout.  :-P
I18N_PATCH = true
#TODO
#wrap tag helpers
#  def text_field
# /usr/lib/ruby/gems/1.8/gems/actionpack-2.3.8/lib/action_view/helpers/form_helper.rb
#  def text_field_tag
# /usr/lib/ruby/gems/1.8/gems/actionpack-2.3.8/lib/action_view/helpers/form_tag_helper.rb:

if I18N_PATCH == true
  module ActionView
    module Helpers
      module TranslationHelper
        alias :old_translate :translate
        
        def translate(*args)
          key = [*args].first
          key = I18n.locale + '.' + key.to_s
          translation = old_translate(*args)
          translation = "&nbsp;" if translation.blank?
          '<span id="'+key+'" class="i18n-translation">' + translation + '</span>'
        end
        alias :t :translate
      end
    end
  end
else 
  module ActionView
    module Helpers
      module TranslationHelper
         def include_i18n_tools
         end
      end
    end
  end
end


