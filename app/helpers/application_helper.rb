# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def render_field(builder, method, label=nil, &block)
    #label ||= t("activerecord.attributes.#{builder.object.class.name.underscore}.#{method}")
    label ||= t("activerecord.attributes.#{builder.object_name}.#{method}")
    <<-END
    <tr>
      <td><label for='#{builder.object_name}_#{method}' >#{label}:</label></td>
      <td>#{block_given? ? yield : builder.text_field(method)}</td>
    </tr>
    END
  end
end
