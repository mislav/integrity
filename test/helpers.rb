require "integrity"

missing = []
%w[test/unit redgreen context storyteller pending matchy rr mocha ruby-debug].each do |lib|
  begin
    require lib
  rescue LoadError
    missing << lib
  end
end

unless missing.empty? or missing == ['redgreen']
  puts "You're missing some gems required to run the tests: #{missing.join(', ')}"
  puts "Please run `rake test:install_dependencies`"
  puts "You'll probably need to run that command as root or with sudo."
  puts
  puts "Thanks :)"
  puts

  exit 1
end

require File.dirname(__FILE__) / "helpers" / "expectations"
require File.dirname(__FILE__) / "helpers" / "fixtures"

module TestHelper
  def setup_and_reset_database!
    DataMapper.setup(:default, "sqlite3::memory:")
    DataMapper.auto_migrate!
  end

  def ignore_logs!
    stub(Integrity).log { nil }
  end
end

class Test::Unit::TestCase
  class << self
    alias_method :specify, :test
  end

  include RR::Adapters::TestUnit
  include Integrity
  include TestHelper
end

