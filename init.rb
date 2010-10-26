require 'redmine'

Redmine::Plugin.register :redmine_changelogs do
  name 'Redmine Changelogs plugin'
  author 'Eric Davis'
  description 'Show the changelogs for a project in Redmine'
  url 'https://projects.littlestreamsoftware.com/projects/redmine-changelogs'
  author_url 'http://www.littlestreamsoftware.com'
  version '0.1.0'

  permission(:view_issue_changelogs, {:changelogs => [:show]})
end
require 'redmine_changelogs/hooks/view_issues_sidebar_issues_bottom_hook'
