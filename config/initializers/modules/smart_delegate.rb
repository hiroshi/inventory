# TODO: to be plugin
# I hardly explain functionality of smart_delegate, but this:
#
#  class User < ActiveRecord::Base
#    belongs_to :group
#    smart_delegate :group, :name
#  end 
#
# will be expanded as:
#
#  class User < ActiveRecord::Base
#    belongs_to :group
#    def group_name=(value)
#      @group_name = value
#    end
#    def group_name
#      @group_name ||= self.group.try(:name)
#    end
#    before_save :set_group
#    def set_group
#      self.group = Group.find_or_create_by_name(@group_name)
#    end
#  end
#
module SmartDelegate
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def smart_delegate(association, method, options={})
      name = "#{association}_#{method}"
      define_method "#{name}=" do |value|
        value = value.strip.gsub(/\s+/, " ") if options[:strip_spaces]
        instance_variable_set("@#{name}", value)
      end
      define_method name do
        instance_variable_get("@#{name}") || instance_variable_set("@#{name}", self.send(association).try(method))
      end
      before_save do |record|
        klass = record.class.inheritable_attributes[:reflections][association].klass
        value = record.instance_variable_get("@#{name}")
        record.send("#{association}=", klass.find(:first, :conditions => {method => value}) || klass.create!(method => value))
      end
    end
  end
end

ActiveRecord::Base.send :include, SmartDelegate
