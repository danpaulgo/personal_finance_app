module ApplicationHelper

  def show_flash
    if !flash.empty?
      flash.each do |message_type, message| 
        content_tag(:div, message)
      end
    end
  end

end
