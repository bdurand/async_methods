require 'async_methods/async_methods'
Object.send(:include, AsyncMethods::InstanceMethods) unless Object.include?(AsyncMethods::InstanceMethods)
