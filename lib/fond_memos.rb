require 'fond_memos/version'

# Include this module in classes that have methods you want to memoize. It is
# very simple, so skim through the code before you use it just to feel extra
# secure in using it, and also to help me find any bugs.
#
# Eg:
#
# Class Foo
#   include FondMemos
#
#   def bar
#     # expensive calculation
#   end
#   memoize :bar
# end

# foo = Foo.new
# foo.bar  # expensive
# foo.bar  # fast
# foo.forget(:bar)
# foo.bar  # expensive again (why did you forget?)
# foo.bar  # fast again (that's better)
#
# If you memoize a method with arguments, the #hash method will be called on
# each argument to generate a key to use in FondMemo's internal hash.
# To ensure safe and responsible memoizing, it is strongly encouraged to ensure
# your memoized method arguments have logical hash values.
#
# May you always have fond memos of using this gem!
module FondMemos
  def self.included(base)
    base.extend ClassMethods
  end

  # Calling this will remove the caching instance variable for the method.
  # In the case of multi argument methods, all values will be forgotten.
  # @param method [Symbol] the method to forget
  def forget(method)
    remove_instance_variable(Internal.var_name(method))
  end

  private

  def _fond_fetch(var_name, original_method)
    return instance_variable_get(var_name) if instance_variable_defined?(var_name)
    instance_variable_set(var_name, original_method.bind(self).call)
  end

  def _fond_multi_fetch(var_name, original_method, args)
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
          define_method(m) { _fond_fetch(var_name, original_method) }
        else
          define_method(m) { |*args| _fond_multi_fetch(var_name, original_method, args) }
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
