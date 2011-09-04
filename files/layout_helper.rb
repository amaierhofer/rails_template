# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
  end

  def generate_class
    "#{controller_name}-#{controller.action_name}"
  end  

  def flash_for_pjax
    return unless requests_and_wants_pjax?
    str = ""
    flash.each do |name, msg| 
      str += content_tag :div, msg, :class => "flash flash-#{name}"
    end
    str.html_safe
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
end
