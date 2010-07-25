require 'rubygems'
require 'term/ansicolor'
require 'win32console'
require 'albacore/support/albacore_helper'

include Term::ANSIColor

class Build
  extend AttrMethods
  include RunCommand
  include YAMLConfig

  def solution=(solution)
    @env.solution = solution
  end

  def application_type=(application_type)
    @env.application_type = application_type
  end

  def initialize(env)
    @env = env
  end

  def execute()
    raise "Application type not specified" if @env.application_type.nil?

    stages = {
      "clean" => [Clean],
      "compile" => [Tokenize, Compile],
      "test" => [UnitTests,Specs, StyleCop],
      "publish" => [Copy, Verify],
      "analyze" => [NDepend, CodeCoverage, PageSpeed]
    }

    ["clean", "compile", "test", "publish", "analyze"].each do |stage|
      @env.log_block stage do 
        stages[stage].each do |t|
          t = t.new(@env)
          @@env.log(t.description, :info)
          t.execute()
        end
      end
    end
  end
end