require 'test_helper'

class FondMemosTest < Minitest::Test
  PERFORMANCE_COUNT = 100_000

  def test_that_it_has_a_version_number
    refute_nil ::FondMemos::VERSION
  end

  class Memoized
    include FondMemos

    attr_reader :run_count, :multi_arg_calls

    def initialize
      @run_count = 0
      @multi_arg_calls = Hash.new(0)
    end

    def memoized
      @run_count += 1
      'hello'
    end

    def multi_arg(a, b)
      multi_arg_calls["#{a}+#{b}"] += 1
      a + b
    end

    memoize :memoized, :multi_arg

    def traditional_memoization
      if defined?(@traditional)
        @traditional
      else
        @traditional = 'hello'
      end
    end

    def traditional_multi_arg(a, b)
      @traditional_multi = {} unless defined?(@traditional_multi)

      @traditional_multi[[a, b]] ||= a + b
    end
  end

  def setup
    @obj = Memoized.new
    assert_equal 0, obj.run_count
  end

  attr_reader :obj

  def call_memoized(expected_run_count)
    assert_equal 'hello', obj.memoized
    assert_equal expected_run_count, obj.run_count
  end

  def call_multi_arg(a, b, expected_count: 1)
    assert_equal a + b, obj.multi_arg(a, b)
    assert_equal expected_count, obj.multi_arg_calls["#{a}+#{b}"]
  end

  def test_only_run_once
    call_memoized(1)
    call_memoized(1)
  end

  def test_multi_arg
    call_multi_arg(3, 2)
    refute obj.multi_arg_calls.keys.include?('2+3')

    call_multi_arg(3, 2)
    refute obj.multi_arg_calls.keys.include?('2+3')

    call_multi_arg(2, 3)
    assert_equal 1, obj.multi_arg_calls['3+2']
  end

  def test_forget
    call_memoized(1)

    obj.forget(:memoized)

    call_memoized(2)
    call_memoized(2)

    call_multi_arg(5, 3)
    obj.forget(:multi_arg)
    call_multi_arg(5, 3, expected_count: 2)
  end

  def test_performance
    require 'benchmark'

    traditional = Benchmark.realtime do
      PERFORMANCE_COUNT.times { obj.traditional_memoization }
    end

    fond = Benchmark.realtime do
      PERFORMANCE_COUNT.times { obj.memoized }
    end

    puts "ratio: #{traditional / fond}"
  end

  def test_multi_performance
    require 'benchmark'
    traditional_multi = Benchmark.realtime do
      PERFORMANCE_COUNT.times { obj.traditional_multi_arg(5, 3) }
    end

    fond_multi = Benchmark.realtime do
      PERFORMANCE_COUNT.times { obj.multi_arg(5, 3) }
    end

    puts "ratio: #{traditional_multi / fond_multi}"
  end
end
