require 'didya_get_the_memo/version'

# Include this module in classes that have methods you want to memoize.
module DidyaGetTheMemo
  def self.included(base)
    base.extend ClassMethods
  end

  # Calling this will remove the caching instance variable for the method
  # @param method [Symbol] the method to forget
  def forget(method)
    remove_instance_variable(Internal.var_name(method))
  end

  private

  def _didya_fetch(var_name, original_method)
    return instance_variable_get(var_name) if instance_variable_defined?(var_name)
    instance_variable_set(var_name, original_method.bind(self).call)
  end

  def _didya_multi_fetch(var_name, original_method, args)
    instance_variable_set(var_name, {}) unless instance_variable_defined?(var_name)
    hash = instance_variable_get(var_name)
    key = args.map(&:hash)
    if hash.key?(key)
      hash[key]
    else
      hash[key] = original_method.bind(self).call(*args)
    end
  end

  #:nodoc:
  module ClassMethods
    # Add memoization for the listed methods
    # @param methods [Array<Symbol>] the methods to memoize
    def memoize(*methods)
      methods.each do |m|
        original_method = instance_method(m)
        var_name = Internal.var_name(original_method.name)
        if original_method.arity.zero?
          define_method(m) { _didya_fetch(var_name, original_method) }
        else
          define_method(m) { |*args| _didya_multi_fetch(var_name, original_method, args) }
        end
      end
    end
  end

  #:nodoc:
  module Internal
    def self.var_name(method)
      "@memoized_#{method}".to_sym
    end
  end
end
