class Tools
  attr_accessor :nunit, :mspec, :tools_dir

  def initialize(env)
    @tools_dir = env.root + '/build/tools/'
    @nunit =  @tools_dir + 'nunit/nunit-console.exe'
    @mspec =  @tools_dir + 'mspec/mspec.exe'
  end

  def to_s
    "\tNUnit runner: #{@nunit}\n\tMSpec runner: #{@mspec}"
  end
end