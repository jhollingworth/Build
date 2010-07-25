class PageSpeed
  def description()
    "Analyzing speed of web application"
  end

  def initialize(env)
    @env = env
  end

  def execute()
    if @env.website?
      @env.log("Not implemented", :warn)
    else
      puts "Not calculating page speed because the application is not a website".yellow
    end
  end
end