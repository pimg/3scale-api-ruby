require 'bundler/gem_tasks'
task default: :spec

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  # no rspec available
end

begin
  require 'yard'

  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/**/*.rb']
    t.options = ['--api' 'public']
  end
rescue LoadError
  # no yard available
end
