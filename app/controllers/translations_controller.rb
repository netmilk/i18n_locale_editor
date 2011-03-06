class TranslationsController < ApplicationController
  before_filter :set_language, :except => [:index]
  skip_before_filter :verify_authenticity_token, :only => [:set_value]
  #TODO remove
  skip_before_filter :admin_required, :login_required
  layout 'translations'


  def index
    session[:i18n_locale_editor_translations] = [I18n.available_locales.first] if session[:i18n_locale_editor_translations].blank?
    session[:i18n_show_only_incomplete] = false if session[:i18n_show_only_incomplete].blank?
    
    @translations = Translation.merge_locales session[:i18n_locale_editor_translations], session[:i18n_show_only_incomplete] 

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @translations }
    end
  end

  def get_value
    value = Translation.all(@language).find_by_path(params[:path])
    render :text => value
  end
  
  def set_value
    Translation.update_by_path(@language, params[:path], params[:value])
    I18n.reload!
    render :text => "OK"
  end

  def set_translations
    session[:i18n_locale_editor_translations] = params[:translations]
    session[:i18n_show_only_incomplete] = true if params[:show_only_incomplete] == "true"
    session[:i18n_show_only_incomplete] = false if params[:show_only_incomplete] == "false"
    redirect_to :action => 'index'
  end
  
  private
  
  def set_language
    @language = params[:path].split(".").first if not params[:path].nil?
#    @language = I18n.locale if not I18n.available_locales.include? @language
  end
end
