class Verify
  def description()
    "Verifying publication success"
  end

  def initialize(env)
    @env = env
  end

  def execute()
    @env.log("Not implemented", :warn)
  end
end