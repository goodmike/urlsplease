# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, comment the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
end


module MockModels

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end
  
  def mock_tag(stubs={})
    @mock_tag  ||= mock_model(Tag, stubs)
  end
  
  def mock_request(stubs={})
    @mock_request ||= mock_model(Request, stubs)
  end
   
  def mock_resource(stubs={})
    @mock_resource ||= mock_model(Resource, stubs)
  end
  
end



class Hash

  ##
  # Filter keys out of a Hash.
     #
  #   { :a => 1, :b => 2, :c => 3 }.except(:a)
  #   => { :b => 2, :c => 3 }

  def except(*keys)
    self.reject { |k,v| keys.include?(k || k.to_sym) }
  end
  
  alias without except

  ##
  # Override some keys.
  #
  #   { :a => 1, :b => 2, :c => 3 }.with(:a => 4)
  #   => { :a => 4, :b => 2, :c => 3 }

  def with(overrides = {})
    self.merge overrides
  end

  ##
  # Returns a Hash with only the pairs identified by +keys+.
  #
  #   { :a => 1, :b => 2, :c => 3 }.only(:a)
  #   => { :a => 1 }

  def only(*keys)
    self.reject { |k,v| !keys.include?(k || k.to_sym) }
  end
  
  def to_display_string
    "{" + self.keys.collect {|k|
      if self[k].class == Hash
        %Q!:#{k} => "#{self[k].to_display_string}"!
      else
        %Q!:#{k} => "#{self[k]}"!
      end
    }.join(", ") + "}"
  end
  
end