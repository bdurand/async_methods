require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'async_methods', 'async_methods'))
Object.send(:include, AsyncMethods::InstanceMethods) unless Object.include?(AsyncMethods::InstanceMethods)
require File.expand_path(File.dirname(__FILE__) + '/method_tester')

describe AsyncMethods::InstanceMethods do
  
  let(:object) { AsyncMethods::Tester.new }
  
  it "should inject async method handling" do
    proxy = object.async_test("arg")
    proxy.to_s.should == "ARG"
    proxy.__proxy_loaded__.should == true
  end
  
  it "should return a proxy object that has not been invoked yet" do
    proxy = object.async_test("arg", 1)
    proxy.__proxy_loaded__.should == false
  end
  
  it "should be able to run a block asynchronously" do
    proxy = asynchronous_block{object.test("arg", 0.1)}
    proxy.__proxy_loaded__.should == false
    proxy.to_s.should == "ARG"
    proxy.__proxy_loaded__.should == true
  end
  
  it "should remove itself from stacktraces thrown in method_missing" do
    begin
      "object".call_a_missing_method_that_does_not_exist
      raise "should not get here"
    rescue => e
      async_source_file = File.expand_path("../../lib/async_methods/async_methods.rb", __FILE__)
      File.exist?(async_source_file).should == true
      e.backtrace.join("\n").should_not include(async_source_file)
    end
  end
end

describe AsyncMethods::Proxy do
  
  let(:object) { AsyncMethods::Tester.new }
  
  it "should be able to wrap a method without waiting for it to finish" do
    proxy = object.async_test("arg", 1)
    object.test_called.should == 0
  end
  
  it "should execute the wrapped method when it needs to" do
    proxy = object.async_test("arg")
    proxy.to_s
    object.test_called.should == 1
  end
  
  it "should only execute the wrapped method once" do
    proxy = object.async_test("arg")
    proxy.to_s
    proxy.to_s
    object.test_called.should == 1
  end
  
  it "should allow nil as a valid proxied value" do
    proxy = object.async_test(nil)
    proxy.should_not
    object.test_called.should == 1
  end
  
  it "should allow blocks in the async method" do
    n = 1
    proxy = object.async_test("arg", 0.1) do
      n = 2
    end
    n.should == 1
    proxy.to_s
    n.should == 2
  end
  
  it "should be indistinguishable from the real object" do
    proxy = object.async_test("arg")
    proxy.class.should == String
    proxy.kind_of?(String).should == true
  end
  
  it "should proxy core methods on Object" do
    proxy = "xxx".async_to_s
    proxy.should == "xxx"
  end
  
  it "should proxy missing methods" do
    proxy = object.async_find_test
    proxy.to_s.should == "FINDER"
  end
  
  it "should allow blocks in the async missing methods" do
    n = 1
    proxy = object.async_find_test do
      n = 2
    end
    n.should == 2
  end
  
  it "should not interfere with the proxied object's method_missing" do
    real = object.find_test
    real.to_s.should == "FINDER"
  end
  
  it "should not interfere with real methods that begin with async_" do
    object.async_real_method_called.should == false
    object.async_real_method
    object.async_real_method_called.should == true
  end
  
  it "should not open a new thread if Thread.critical is true" do
    begin
      Thread.critical = true
      Thread.should_not_receive(:new)
      proxy = "xxx".async_to_s
      proxy.should == "xxx"
    ensure
      Thread.critical = false
    end
  end
  
end
