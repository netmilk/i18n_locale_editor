ActionController::Routing::Routes.draw do |map|
 map.translations 'translations/get_value/:path', :controller =>  'translations', :action => 'get_value', :method => :get, :requirements => { :path => /.+/ }  
 map.translations 'translations/set_value/:path', :controller =>  'translations', :action => 'set_value', :method => :get, :requirements => { :path => /.+/ }  
 map.translations 'translations/index', :controller =>  'translations', :action => 'index'
end
