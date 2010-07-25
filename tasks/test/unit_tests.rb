class UnitTests
  def description()
     "Running unit tests"
  end

  def initialize(env)
    @env = env
  end

  def execute()

    test_assemblies = FileList[@env.output_dir + '/*tests.dll']

    if test_assemblies.length < 1
      @env.log("Could not find any test assemblies", :warn)
      return
    end
    
    run = nunit do |t|
      t.path_to_command = @env.tools.nunit
      t.assemblies =  test_assemblies
    end
    run.execute
  end
end