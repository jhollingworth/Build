
require "spec"
require File.dirname(__FILE__) + '/../mocks/mock_environment'
require File.dirname(__FILE__) + '/../mocks/mock_file_system'
require File.dirname(__FILE__) + '/../../../build/tasks/clean/clean'

describe "When the output dir does not exist" do

  before(:all) do
    @env = MockEnvironment.new(:output_dir => "output")
    @file_system = MockFileSystem.new("output" => false)
    @task = Clean.new(@env, @file_system)
    @task.execute
  end

  it "should it should not try to delete the folder" do
    @file_system.deleted_folders.key?(@env.output_dir).should == false
  end
end

describe "When the output dir exists" do

  before(:all) do
    @env = MockEnvironment.new(:output_dir => "output")
    @file_system = MockFileSystem.new("output" => true)
    @task = Clean.new(@env, @file_system)
    @task.execute
  end

  it "should it should not try to delete the folder" do
    @file_system.deleted_folders.key?(@env.output_dir).should == true
  end
end