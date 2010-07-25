require 'spec/rake/spectask'

class Specs
  def description()
    "Running specifications"
  end

  def initialize(env)
    @env = env
  end

  def execute()
    test_assemblies =  FileList[@env.output_dir + '/*specs.dll']

    if test_assemblies.length < 1
      @env.log("Could not find any spec assemblies", :warn)
      return      
    end

    run = mspec do |mspec|
      mspec.path_to_command = @env.tools.mspec
      mspec.assemblies = test_assemblies
    end
    run.execute
  end
end