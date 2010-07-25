class NDepend
  def description()
    "Analyzing coupling of code"
  end


  def initialize(env)
    @env = env
  end

  def execute()
    @env.log("Not implemented", :warn)
  end
end