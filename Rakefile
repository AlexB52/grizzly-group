require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

# task :default => :test
task :default => [:test, :spec]

desc 'Runs the group spec with mspec'
task :spec do
  system 'bundle exec ../mspec/bin/mspec spec/grizzly'
end