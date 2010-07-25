class Clean
  def description()
    "Cleaning up application"
  end

  def initialize(env, fs = FileSystem.new(env))
    @env = env
    @fs = fs
  end

  def execute()
    @fs.delete_folder(@env.output_dir) if @fs.folder_exists(@env.output_dir)
  end
end