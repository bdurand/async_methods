# This class is used for testing the async_methods plugin functionality.

class AsyncMethods::Tester
  
  attr_reader :test_called, :async_real_method_called
  
  def initialize
    @test_called = 0
    @async_real_method_called = false
  end
  
  def test (arg, delay = 0)
    sleep(delay) if delay > 0
    @test_called += 1
    yield if block_given?
    arg.upcase if arg
  end
  
  def async_real_method
    @async_real_method_called = true
  end
  
  def method_missing (method, *args, &block)
    if method.to_s[0, 5] == 'find_'
      yield if block_given?
      "FINDER"
    else
      super
    end
  end
  
end
