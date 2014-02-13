namespace :jasmine do
  desc "Run continuous integration tests with phantom"
  task :phantom => ["jasmine:require_json", "jasmine:require"] do
    require "rspec"
    require "rspec/core/rake_task"

    run_specs = ["#{File.join(File.dirname(__FILE__), '..', 'phantom_jasmine', 'run_specs.rb')}"]
    RSpec::Core::RakeTask.new(:jasmine_continuous_integration_runner) do |t|
      t.rspec_opts = ["--colour", "--format", ENV['JASMINE_SPEC_FORMAT'] || "progress"]
      t.verbose = true
      if Jasmine::Dependencies.use_asset_pipeline?
        t.rspec_opts += ["-r #{File.expand_path(File.join(::Rails.root, 'config', 'environment'))}"]
      end
      t.pattern = run_specs
    end
    Rake::Task["jasmine_continuous_integration_runner"].invoke
  end
end
