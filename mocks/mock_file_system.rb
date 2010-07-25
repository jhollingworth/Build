class MockFileSystem
  attr_accessor :deleted_folders

  def initialize(options)
    @options = options
    @deleted_folders = {}
  end

  def folder_exists(path)
    @options[path]    
  end

  def delete_folder(path)
    @deleted_folders[path] = true
  end
end