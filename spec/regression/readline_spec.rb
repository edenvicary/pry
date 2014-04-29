# These specs ensure that Pry doesn't require readline until the first time a
# REPL is started.

require "helper"
require "shellwords"

describe "Readline" do
  before do
    @ruby    = RbConfig.ruby.shellescape
    @pry_dir = File.expand_path(File.join(__FILE__, '../../../lib')).shellescape
  end

  it "is not loaded on requiring 'pry'" do
    code = <<-RUBY
      require "pry"
      p defined?(Readline)
    RUBY
    `#@ruby -I #@pry_dir -e '#{code}'`.should == "nil\n"
  end

  it "is loaded on invoking 'pry'" do
    code = <<-RUBY
      require "pry"
      Pry.start self, input: StringIO.new("exit-all"), output: StringIO.new
      puts defined?(Readline)
    RUBY
    `#@ruby -I #@pry_dir -e '#{code}'`.end_with?("constant\n").should == true
  end

  it "is not loaded on invoking 'pry' if Pry.input is set" do
    code = <<-RUBY
      require "pry"
      Pry.input = StringIO.new("exit-all")
      Pry.start self, output: StringIO.new
      p defined?(Readline)
    RUBY
    `#@ruby -I #@pry_dir -e '#{code}'`.end_with?("nil\n").should == true
  end
end
