#!/usr/bin/env ruby
require 'redmine_plugin_support'

Dir[File.expand_path(File.dirname(__FILE__)) + "/lib/tasks/**/*.rake"].sort.each { |ext| load ext }

RedminePluginSupport::Base.setup do |plugin|
  plugin.project_name = 'redmine_changelogs'
  plugin.default_task = [:test]
  plugin.tasks = [:db, :doc, :release, :clean, :test, :stats, :metrics]
  # TODO: gem not getting this automaticly
  plugin.redmine_root = File.expand_path(File.dirname(__FILE__) + '/../../../')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "redmine_changelogs"
    s.summary = "Show the changelogs for a project in Redmine."
    s.email = "edavis@littlestreamsoftware.com"
    s.homepage = "https://projects.littlestreamsoftware.com/projects/redmine-changelogs"
    s.description = "Show the changelogs for a project in Redmine. Was removed in the Redmine core in r3162."
    s.authors = ["Eric Davis"]
    s.rubyforge_project = "TODO" # TODO
    s.files =  FileList[
                        "[A-Z]*",
                        "init.rb",
                        "rails/init.rb",
                        "{bin,generators,lib,test,app,assets,config,lang}/**/*",
                        'lib/jeweler/templates/.gitignore'
                       ]
  end
  Jeweler::GemcutterTasks.new
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

