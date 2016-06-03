require 'didya_get_the_memo/version'

# Include this module in classes that have methods you want to memoize.
module DidyaGetTheMemo
  def self.included(base)
    base.extend ClassMethods
  end

  def forget(method)
    remove_instance_variable(Support.var_name(method))
  end

  #:nodoc:
  module ClassMethods
    def memoize(*methods)
      methods.each do |m|
        original_method = instance_method(m)
        var_name = Support.var_name(m)
        define_method(m) do
          next instance_variable_get(var_name) if instance_variable_defined?(var_name)

          instance_variable_set(var_name, original_method.bind(self).call)
        end
      end
    end
  end

  #:nodoc:
  module Support
    def self.var_name(method)
      "@memoized_#{method}".to_sym
    end
  end
end
