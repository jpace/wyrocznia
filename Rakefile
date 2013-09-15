require 'rubygems'
require 'rake/testtask'
require 'rubygems/package_task'
require 'fileutils'

Dir['tasks/**/*.rake'].each { |t| load t }

task :default => 'test'

Rake::TestTask.new('test') do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.warning = true
  t.verbose = true
end

desc "generate man page"
task :generate_manpage do 
  sh "ronn -r --pipe README.md > man/wyrocznia.1"
end

spec = Gem::Specification.new do |s| 
  s.name               = "wyrocznia"
  s.version            = "0.0.1"
  s.author             = "Jeff Pace"
  s.email              = "jeugenepace@gmail.com"
  s.homepage           = "https://github.com/jpace/wyrocznia"
  s.platform           = Gem::Platform::RUBY
  s.summary            = "A program to test knowledge of words."
  s.description        = "A program to test using word lists, matching possible letter combinations."
  s.files              = FileList["{bin,lib,man,resources}/**/*"].to_a
  s.require_path       = "lib"
  s.test_files         = FileList["{test}/**/*test.rb"].to_a
  s.has_rdoc           = false
  s.bindir             = 'bin'
  s.executables        = %w{ wyrocznia }
  s.default_executable = 'wyrocznia'
  s.license            = 'MIT'

  s.add_dependency("rainbow", ">= 1.1.4")
end
 
Gem::PackageTask.new(spec) do |pkg| 
  pkg.need_zip = true 
  pkg.need_tar_gz = true 
end 
