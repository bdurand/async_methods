require File.expand_path('../async_methods/async_methods', __FILE__)
Object.send(:include, AsyncMethods::InstanceMethods) unless Object.include?(AsyncMethods::InstanceMethods)
