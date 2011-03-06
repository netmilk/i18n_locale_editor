#LOCED
require 'ya2yaml'
require 'fileutils'

class Translation 

  def self.all(locale)
    locale = locale.to_s
    file = File.join(RAILS_ROOT, "config/locales","#{locale}.yml")
    hash = YAML::load_file file
  end
  
  def self.update_by_path(locale,path,value)
    locale = locale.to_s

    file = File.join(RAILS_ROOT, "config/locales","#{locale}.yml")
    hash = YAML::load_file file
    hash.update_by_path(path,value)
    File.open(file + ".new",'w') do |f|
        f.puts hash.ya2yaml
    end
    FileUtils.mv(file + ".new", file)
  end
  
  def self.merge_locales locales_array, only_missing = false
    #available_locales = I18n.available_locales.map{|loc| loc.to_s}
    #locales_array.each{|loc| raise "#{loc} locale not found" if not available_locales.include? loc.to_s }

    paths = []
    translations = {}
    locales_array.each do |locale|
      translations[locale] = translation = Translation.all(locale)
      paths = paths + translation.paths.map{|path| path.gsub(/^#{locale.to_s}\./,"")}
    end 
    paths = paths.uniq
    
    aggreg = {}
    paths.each do |path|
      aggreg[path] = {}
      locales_array.each do |locale|
        aggreg[path][locale] = translations[locale].find_by_path(locale + '.' + path)
      end
    end
    if only_missing
      return aggreg.delete_if do |path,translation|
        ret = true
        translation.each do |language, value|
           ret = false if value.blank?
        end
        
        ret
      end
    else
      return aggreg
    end
    
  end
end
 