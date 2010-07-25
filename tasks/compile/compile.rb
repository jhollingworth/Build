class Compile
  def description()
    "Compiling the application"
  end

  def initialize(env)
    @env = env
  end

  def execute()
    begin
      build = msbuild :msbuild do |msb|
        msb.properties :configuration => @env.local? ? :Debug : :Release, :outdir  => @env.output_dir
        msb.targets :Clean, :Build
        msb.solution = @env.root + '/' + @env.solution
        msb.verbosity = :quiet
      end
      build.execute
    rescue Exception => e
      @env.log(e.message, :error)
      raise e 
    end
  end
end