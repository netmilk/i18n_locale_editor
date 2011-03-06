require 'hash_tools'
require 'translate_monkey_patch'

%w{ models controllers helpers }.each do |dir|
  path = File.join(directory, 'app',dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end

require File.join(directory, "app", "helpers", "translations_helper.rb")
ActionView::Base.send :include, TranslationsHelper;
