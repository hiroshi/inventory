# Chainning up named scopes by a params hash.
# Usage example: 
#   class User
#     named_scope :age, lambda{|age| {:conditions => ["age = ?", age]}}
#     named_scope :city, lambda{|city| {:conditions => ["city = ?", city]}}
#   end
# 
#   class UsersController < ApplicationController
#     def index
#       params # => {:age => 30, :city => "Tokyo"}
#       @users = User.params_scope(params).find(:all) # => User.age(30).city("Tokyo").find(:all)

module ParamsScope
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def params_scope(params)
      self.scopes.keys.inject(self) do |ret, scope_name|
        if (value = (params[scope_name] || params[scope_name.to_s])) && !value.blank?
          ret.send(scope_name, *value)
        else
          ret
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, ParamsScope)
ActiveRecord::Associations::AssociationProxy.send(:include, ParamsScope::ClassMethods)
