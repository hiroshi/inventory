class TableFormBuilder < ActionView::Helpers::FormBuilder
  def tr(method, options={}, &block)
    # Get label texts from localized attribute names
    # NOTE: object_name may have nested name such as "asset[utilzation]" in form.fields_for block
    #label = options[:label] || @template.t("activerecord.attributes.#{self.object_name}.#{method}")
    # NOTE: object.class may differ from explicitly specified object_name by form_for(object_naem, object, ...)
    label = options[:label] || @template.t("activerecord.attributes.#{self.object.class.name.underscore}.#{method}")

    @template.concat "<tr><td><label for='#{self.object_name}_#{method}'>#{label}:</label></td><td>"
    yield method
    @template.concat "</td></tr>"
  end
end
