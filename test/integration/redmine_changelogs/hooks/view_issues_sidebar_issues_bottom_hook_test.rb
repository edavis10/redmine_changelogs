require File.dirname(__FILE__) + '/../../../test_helper'

class RedmineChangelogs::Hooks::ViewIssuesSidebarIssuesBottomTest < ActionController::IntegrationTest
  include Redmine::Hook::Helper

  context "#view_issues_sidebar_issues_bottom for user with permission to view changelogs" do
    setup do
      @user = User.generate!(:login => "existing", :password => "existing", :password_confirmation => "existing", :admin => true)
      @project = Project.generate!.reload
      @issue = Issue.generate_for_project!(@project)
      login_as
    end

    should "add a link to the changelog view when viewing a project's issue page" do
      visit_issue_page(@issue)

      assert_select "a#changelog", :text => /Change log/
      click_link "Change log"

      assert_response :success
      assert_equal "/projects/#{@project.to_param}/changelog", current_path
    end

    should "add nothing on the cross project issue list" do
      visit '/issues'

      assert_select "a#changelog", :text => /Change log/, :count => 0

    end
    
  end

  context "#view_issues_sidebar_issues_bottom for user without permission to view changelogs " do
    setup do
      @user = User.generate!(:login => "existing", :password => "existing", :password_confirmation => "existing")
      @project = Project.generate!
      @issue = Issue.generate_for_project!(@project)
      @role = Role.generate!(:permissions => [:view_issues])
      User.add_to_project(@user, @project, @role)
      login_as
    end

    should "add nothing on the project's issue page" do
      visit_issue_page(@issue)

      assert_select "a#changelog", :text => /Change log/, :count => 0
    end

    should "add nothing on the cross project issue list" do
      visit '/issues'

      assert_select "a#changelog", :text => /Change log/, :count => 0

    end
    
  end
end
