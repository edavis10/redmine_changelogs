require 'test_helper'

class ChangelogsShowTest < ActionController::IntegrationTest
  def setup
    @project = Project.generate!.reload
    @issue = Issue.generate_for_project!(@project)
  end
  
  context "for a user with permission to view changelogs" do
    setup do
      @user = User.generate!(:login => "existing", :password => "existing", :password_confirmation => "existing")
      @role = Role.generate!(:permissions => [:view_issues, :view_issue_changelogs])
      User.add_to_project(@user, @project, @role)
      login_as
      visit_changelogs_for_project(@project)
    end

    should "load the changelogs page" do
      assert_select "h2", "Change log"
    end

  end

  context "for a user without permission to view changelogs" do
    setup do
      @user = User.generate!(:login => "existing", :password => "existing", :password_confirmation => "existing")
      @role = Role.generate!(:permissions => [:view_issues]) # Missing permission
      User.add_to_project(@user, @project, @role)
      login_as
    end

    should "show the unauthorized page" do
      visit_issue_page(@issue)

      assert_select "a#changelog", :text => /Change log/, :count => 0

      # Url hacking
      visit "/projects/#{@project.to_param}/changelog"
      assert_forbidden
    end
  end
  
end

