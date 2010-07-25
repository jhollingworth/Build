class CodeCoverage

  def description()
    "Analyzing code coverage"
  end

  def initialize(env)
    @env = env
  end

  def execute()
    @env.log("Not implemented", :warn)
  end
end