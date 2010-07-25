require 'rubygems'
require 'albacore'

$: << File.expand_path(File.dirname(__FILE__))
$: << File.expand_path(File.join(File.dirname(__FILE__), "core"))
$: << File.expand_path(File.join(File.dirname(__FILE__), "tasks"))

['core', 'tasks/clean', 'tasks/compile', 'tasks/test', 'tasks/publish', 'tasks/analyze'].each do |p|
  Dir.glob(File.join(File.expand_path(File.dirname(__FILE__)), p + '/*.rb')).each do |f|
    require f
  end
end

@@env = Environment.new
