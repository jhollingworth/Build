class MockEnvironment
  def initialize(options)
    @options = options
  end

  def output_dir()
    @options[:output_dir]
  end
end