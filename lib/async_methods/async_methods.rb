# Including this module will provide the asynchronous method handling for the class where any method can be
# prefixed with async_ to continue execution without waiting for results. By default, the plugin includes
# it in Object so it is universally available.
module AsyncMethods
  
  module InstanceMethods
    def self.included (base)
      base.send :alias_method, :method_missing_without_async, :method_missing
      base.send :alias_method, :method_missing, :method_missing_with_async
    end
    
    # Override missing method to add the async method handling
    def method_missing_with_async (method, *args, &block)
      if method.to_s[0, 6] == 'async_'
        method = method.to_s
        return Proxy.new(self, method[6 , method.length].to_sym, args, &block)
      else
        # Keep track of the current missing method calls to keep out of an infinite loop
        stack = Thread.current[:async_method_missing_methods] ||= []
        sig = MethodSignature.new(self, method)
        raise NoMethodError.new("undefined method `#{method}' for #{self}") if stack.include?(sig)
        begin
          stack.push(sig)
          return method_missing_without_async(method, *args, &block)
        ensure
          stack.pop
        end
      end
    end
    
    # Call a block asynchronously.
    def asynchronous_block (&block)
      Proxy.new(nil, nil, nil, &block)
    end
  end
  
  # This class is used to keep track of methods being called.
  class MethodSignature
    
    attr_reader :object, :method
    
    def initialize (obj, method)
      @object = obj
      @method = method.to_sym
    end
    
    def eql? (sig)
      sig.kind_of(MethodSignature) and sig.object == @object and sig.method == @method
    end
    
  end
  
  # The proxy object does all the heavy lifting.
  class Proxy
    # These methods we don't want to override. All other existing methods will be redefined.
    PROTECTED_METHODS = %w(initialize __proxy_result__ __proxy_loaded__ method_missing)
    
    def initialize (obj, method, args = [], &block)
      # Override already defined methods on Object to proxy them to the result object
      methods.each do |m|
        eval "def self.#{m} (*args, &block); __proxy_result__.send(:#{m}, *args, &block); end" unless PROTECTED_METHODS.include?(m)
      end
      
      @thread = Thread.new do
        begin
          if obj and method
            @proxy_result = obj.send(method, *args, &block)
          else
            @proxy_result = block.call
          end
        rescue Object => e
          @proxy_exception = e
        end
      end
    end
    
    # Get the result of the original method call. The original method will only be called once.
    def __proxy_result__
      @thread.join if @thread.alive?
      raise @proxy_exception if @proxy_exception
      return @proxy_result
    end
    
    def __proxy_loaded__
      !@thread.alive?
    end
    
    # All missing methods are proxied to the original result object.
    def method_missing (method, *args, &block)
      __proxy_result__.send(method, *args, &block)
    end
  end
  
end
