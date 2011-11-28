require "action_controller/metal"

module ThemesForRails
  class AssetsController < ActionController::Base
    
    include ThemesForRails::CommonMethods
    include ThemesForRails::UrlHelpers
    
    def stylesheets
      render_asset asset_path_for(params[:asset], 'stylesheets'), mime_type_from("#{params[:asset]}.#{params[:format]}")
    end
    
    def javascripts
      render_asset asset_path_for(params[:asset], 'javascripts'), mime_type_from("#{params[:asset]}.#{params[:format]}")  
    end
    
    def images
      render_asset asset_path_for(params[:asset], 'images'), mime_type_from("#{params[:asset]}.#{params[:format]}")  
    end
    
  private
  
    def asset_path_for(asset_url, asset_prefix)
      File.join(theme_path_for(params[:theme]), asset_prefix, "#{params[:asset]}.#{params[:format]}")
    end
    
    def extract_filename_and_extension_from(asset)
      extension = File.extname(asset)
      filename = params[:asset].gsub(extension, '')
      return filename, extension[1..-1]
    end
    
    def render_asset(asset, mime_type)
      unless File.exists?(asset)
        render :text => 'not found', :status => 404
      else
        expires_in 2.days, :public => true if Rails.env.production?
        send_file asset, :type => mime_type, :url_based_filename => true
      end
    end
  
    def mime_type_from(asset_path)
      extension = extract_filename_and_extension_from(asset_path).last
      if extension == 'css'
        "text/css"
      elsif extension == 'js'
        'text/javascript'
      else
        "image/#{extension}"
      end
    end
  end
end
