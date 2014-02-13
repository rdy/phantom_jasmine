$:.unshift(ENV['JASMINE_GEM_PATH']) if ENV['JASMINE_GEM_PATH'] # for gem testing purposes

require 'rubygems'
require 'jasmine'
require 'rspec'
require 'jasmine/runners/phantom'

jasmine_yml = File.join(Dir.pwd, 'spec', 'javascripts', 'support', 'jasmine.yml')
if File.exist?(jasmine_yml)
end

Jasmine.load_configuration_from_yaml

config = Jasmine.config
port = Jasmine.find_unused_port
server = Jasmine::Server.new(port, Jasmine::Application.app(config))
t = Thread.new do
  begin
    server.start
  rescue
  end
  # # ignore bad exits
end
t.abort_on_exception = true
Jasmine::wait_for_listener(port, "jasmine server")
puts "jasmine server started."

results_processor = Jasmine::ResultsProcessor.new(config)
results = Jasmine::Runners::Phantom.new(port, results_processor, config.result_batch_size).run
formatter = Jasmine::RspecFormatter.new
formatter.format_results(results)
