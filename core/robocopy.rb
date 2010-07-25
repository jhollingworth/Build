class Robocopy
  attr_accessor :files, :directories, :destination

  def initialize(env, executor = Executor.new)
    @env = env
    @files = []
    @directories = []
    @executor = executor
  end

  def execute()
    raise "No files or directories were specified" if @files.length == 0 and @directories.length == 0
    raise "Destination folder was not specified" if @destination.nil?

    copy = lambda { |type, collection|
      collection.each do |f|
        command = eval "#{type}_command(f, @destination)"
        @env.log("Copying #{f} #{destination}; #{command}", :info)
        @executor.run("robocopy #{command}")
      end
    }
    
    copy.call('file', @files)
    copy.call('directory', @directories)
  end

  private

  def file_command(path, destination)
    "#{File.dirname(path)} #{destination} #{File.basename(path)}"
  end

  def directory_command(path, destination)
    "#{path} #{destination} /E"
  end
end

class Executor
  def run(command)
    %[#{command}]
  end
end
