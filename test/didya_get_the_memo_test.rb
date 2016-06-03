require 'test_helper'

class DidyaGetTheMemoTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::DidyaGetTheMemo::VERSION
  end

  class Memoized
    include DidyaGetTheMemo

    attr_reader :run_count

    def initialize
      @run_count = 0
    end

    def foo
      @run_count += 1
      'hello'
    end
    memoize :foo
  end

  def test_only_run_once
    obj = Memoized.new
    assert_equal 0, obj.run_count

    assert_equal 'hello', obj.foo
    assert_equal 1, obj.run_count

    assert_equal 'hello', obj.foo
    assert_equal 1, obj.run_count
  end
end
