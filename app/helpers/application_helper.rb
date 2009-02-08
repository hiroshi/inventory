# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # TODO: to be plugin
  # TODO: implement FormTagHelper like version
  def auto_complete_combo_box_tag(name, options, value = nil, tag_options = {}, completion_options = {})
    array = options.to_json
    value ||= params[name]

    (completion_options[:skip_style] ? "" : auto_complete_stylesheet) +
    text_field_tag(name, value, tag_options) +
    content_tag("div", "", :id => "#{name}_auto_complete", :class => "auto_complete") +
    javascript_tag("var #{name}_auto_completer = new Autocompleter.LocalCombo('#{name}', '#{name}_auto_complete', #{array}, {frequency:0.1, partialSearch:true, fullSearch:true, partialChars:1});") +
    link_to_function("▼", "#{name}_auto_completer.toggle();", :style => "text-decoration:none; border:thin solid gray")
    # TODO: to be more pretty button (i.e. use image)
  end

#   def render_field(builder, method, label=nil, &block)
#     #label ||= t("activerecord.attributes.#{builder.object.class.name.underscore}.#{method}")
#     label ||= t("activerecord.attributes.#{builder.object_name}.#{method}")
#     <<-END
#     <tr>
#       <td><label for='#{builder.object_name}_#{method}' >#{label}:</label></td>
#       <td>#{block_given? ? yield : builder.text_field(method)}</td>
#     </tr>
#     END
#   end
end
