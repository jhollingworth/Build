require 'yaml'
require 'fileutils'
require 'term/ansicolor'
require 'win32console'
require File.dirname(__FILE__) + '/tools'

include Term::ANSIColor

class Environment
  attr_accessor :environment, :tools, :root, :solution, :application_type, :output_dir

  def initialize()
    @environment = ENV['env'] || 'local'
    @root = ENV['root'] || File.dirname(__FILE__) + '/../../'
    @output_dir = @root + 'output/'
    @config = YAML.load(File.read(@root + '/build/config.yaml'))
    @tools = Tools.new(self)

    log(self.to_s, :info)
  end

  def config(key)
    config = @config[key]
    return config[@environment] if config.class == Hash and !config[@environment].nil?
    return config
  end

  def to_s
    "Environment: #{@environment}\n" +
    "Root dir: #{@root}\n" +
    "Output directory: #{@output_dir}\n" +
    "Tools:\n#{@tools}"             
  end

  def teamcity?()
    ENV['TEAMCITY_VERSION'] != nil
  end

  def local?()
    @environment == 'local'
  end

  def live?()
    @environment == 'live'
  end

  def website?()
    @application_type == :website
  end

  def log(message, type)

    if teamcity?
      teamcity_type = case type
        when :info then 'NORMAL'
        when :warn then 'WARNING'
        when :error then 'FALIURE'
        else raise "Unknown type"
      end
      puts "##teamcity[message text='#{tc_sanitize(message)}' status='#{teamcity_type}']"
    else
      puts case type
        when :info then message.green
        when :warn then message.yellow
        when :error then message.red
        else raise "Unknown type"
      end
    end
  end

  def log_block(block_name)
    puts "##teamcity[blockOpened name='#{block_name}']" if teamcity?
    yield 
    puts "##teamcity[blockClosed name='#{block_name}']" if teamcity? 
  end

  private

  def tc_sanitize(message)
    message.gsub(/\n/,'|n').gsub(/'/, '|').gsub(/]/,'|]')
  end
end

