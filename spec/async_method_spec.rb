require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'async_methods', 'async_methods'))
Object.send(:include, AsyncMethods::InstanceMethods) unless Object.include?(AsyncMethods::InstanceMethods)
require File.expand_path(File.dirname(__FILE__) + '/method_tester')

context "AsyncMethods InstanceMethods" do
  
  let(:object) { AsyncMethods::Tester.new }
  
  specify "should inject async method handling" do
    proxy = object.async_test("arg")
    proxy.to_s.should == "ARG"
    proxy.__proxy_loaded__.should == true
  end
  
  specify "should return a proxy object that has not been invoked yet" do
    proxy = object.async_test("arg", 1)
    proxy.__proxy_loaded__.should == false
  end
  
  specify "should be able to run a block asynchronously" do
    proxy = asynchronous_block{object.test("arg", 0.1)}
    proxy.__proxy_loaded__.should == false
    proxy.to_s.should == "ARG"
    proxy.__proxy_loaded__.should == true
  end
  
end

context "AsyncMethods Proxy" do
  
  let(:object) { AsyncMethods::Tester.new }
  
  specify "should be able to wrap a method without waiting for it to finish" do
    proxy = object.async_test("arg", 1)
    object.test_called.should == 0
  end
  
  specify "should execute the wrapped method when it needs to" do
    proxy = object.async_test("arg")
    proxy.to_s
    object.test_called.should == 1
  end
  
  specify "should only execute the wrapped method once" do
    proxy = object.async_test("arg")
    proxy.to_s
    proxy.to_s
    object.test_called.should == 1
  end
  
  specify "should allow nil as a valid proxied value" do
    proxy = object.async_test(nil)
    proxy.should_not
    object.test_called.should == 1
  end
  
  specify "should allow blocks in the async method" do
    n = 1
    proxy = object.async_test("arg", 0.1) do
      n = 2
    end
    n.should == 1
    proxy.to_s
    n.should == 2
  end
  
  specify "should be indistinguishable from the real object" do
    proxy = object.async_test("arg")
    proxy.class.should == String
    proxy.kind_of?(String).should == true
  end
  
  specify "should proxy core methods on Object" do
    proxy = "xxx".async_to_s
    proxy.should == "xxx"
  end
  
  specify "should proxy missing methods" do
    proxy = object.async_find_test
    proxy.to_s.should == "FINDER"
  end
  
  specify "should allow blocks in the async missing methods" do
    n = 1
    proxy = object.async_find_test do
      n = 2
    end
    n.should == 2
  end
  
  specify "should not interfere with the proxied object's method_missing" do
    real = object.find_test
    real.to_s.should == "FINDER"
  end
  
  specify "should not interfere with real methods that begin with async_" do
    object.async_real_method_called.should == false
    object.async_real_method
    object.async_real_method_called.should == true
  end
  
end
