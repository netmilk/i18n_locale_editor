require 'hash_tools'
require 'translate_monkey_patch'
require 'ftools'

if ENV['I18N_EDITOR']== "true"
  src = File.join(File.dirname(__FILE__),'public',"i18n-locale-editor.js")
  dst = File.join(RAILS_ROOT,'public', 'javascripts')
  File.copy(src,dst)
end

%w{ models controllers helpers }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app',dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end

require File.join(directory, "app", "helpers", "translations_helper.rb")
ActionView::Base.send :include, TranslationsHelper;

