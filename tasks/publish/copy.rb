require 'fileutils'

class Copy
  def description()
    "Copying files to destination"
  end

  def initialize(env)
    @env = env
  end

  def execute()
    path = eval "#{@env.application_type.to_s}_path"
    destination = @env.config('destination')

    debugger
    if @env.live?
      raise "Zip not implemented"
    elsif @env.local?
      @env.log('Files not copied on the local build', :info)
    else
      @env.log("copying #{path} to #{destination}", :info)
      robocopy do |r|
        r.directories << path
        r.destination = destination
      end
    end
  end

  private

  def website_path()
    dir = @env.output_dir + '_PublishedWebsites'
    Dir.foreach(dir) do |f|
      return "#{dir}/#{f}" if f != '.' and f != '..'
    end
    raise "Could not find the website in the dir #{dir}"
  end
  
end