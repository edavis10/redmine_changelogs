# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

# Ensure that we are using the temporary fixture path
Engines::Testing.set_fixture_path

require "webrat"

Webrat.configure do |config|
  config.mode = :rails
end

def User.add_to_project(user, project, role)
  Member.generate!(:principal => user, :project => project, :roles => [role])
end

module RedmineWebratHelper
  def login_as(user="existing", password="existing")
    visit "/login"
    fill_in 'Login', :with => user
    fill_in 'Password', :with => password
    click_button 'login'
    assert_response :success
    assert User.current.logged?
  end

  def visit_project(project)
    visit '/'
    assert_response :success

    click_link 'Projects'
    assert_response :success

    click_link project.name
    assert_response :success
  end

  def visit_issue_page(issue)
    visit '/issues/' + issue.id.to_s
  end

  def visit_issue_bulk_edit_page(issues)
    visit url_for(:controller => 'issues', :action => 'bulk_edit', :ids => issues.collect(&:id))
  end

  # Cleanup current_url to remove the host; sometimes it's present, sometimes it's not
  def current_path
    return nil if current_url.nil?
    return current_url.gsub("http://www.example.com","")
  end

end

class ActionController::IntegrationTest
  include RedmineWebratHelper
end

class ActiveSupport::TestCase
  def assert_forbidden
    assert_response :forbidden
    assert_template 'common/403'
  end

  def configure_plugin(configuration_change={})
    Setting.plugin_TODO = {
      
    }.merge(configuration_change)
  end

  def reconfigure_plugin(configuration_change)
    Settings['plugin_TODO'] = Setting['plugin_TODO'].merge(configuration_change)
  end
end
