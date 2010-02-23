require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests REPLACED with Rake::setup.'
task :default => :setup

desc 'Test the wuconv plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the wuconv plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Wuconv'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task(:setup) do
  FileUtils.copy('./helpers/w2uconv_helper.rb', '../../../app/helpers')
end