class StyleCop

  def description()
     "Verifying code style"
  end


  def initialize(env)
    @env = env
  end

  def execute()
   @env.log("Not implemented", :warn)
  end
end