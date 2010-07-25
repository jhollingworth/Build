require 'fileutils'
require 'rubygems'
require 'term/ansicolor'

include Term::ANSIColor
class FileSystem
  def initialize(env)
    @env = env
  end

  def folder_exists(path)
    exists = File.directory? path
    @env.log("#{path}#{exists ? "" : " does not"} exists", :info)
    exists
  end

  def delete_folder(path)
    @env.log("Deleting #{path}", :warn)
    FileUtils.rm_rf path    
  end
end