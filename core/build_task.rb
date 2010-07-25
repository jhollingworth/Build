create_task :build, Proc.new { Build.new(@@env)  } do |b|
  b.execute
end