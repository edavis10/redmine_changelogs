require 'test_helper'

class ChangelogsShowTest < ActionController::IntegrationTest
  def setup
    @project = Project.generate!.reload
    @version1 = Version.generate!(:project => @project).reload
    @version2 = Version.generate!(:project => @project).reload
    @closed_status = IssueStatus.generate!(:is_closed => true)
    @issue1 = Issue.generate_for_project!(@project, :status => @closed_status, :fixed_version => @version1)
    @issue2 = Issue.generate_for_project!(@project, :status => @closed_status, :fixed_version => @version1)
    @issue3 = Issue.generate_for_project!(@project, :status => @closed_status, :fixed_version => @version2)
    @issue4 = Issue.generate_for_project!(@project, :status => @closed_status, :fixed_version => @version2)
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

    should "show each version" do
      assert_select "a[name=?]", @version1.name # Anchor link
      assert_select "h3 a", :text => /#{@version1.name}/

      assert_select "ul#version-#{@version1.id}" do
        assert_select "li", :text => /#{@issue1.subject}/
        assert_select "li", :text => /#{@issue2.subject}/
      end

      assert_select "a[name=?]", @version2.name # Anchor link
      assert_select "h3 a", :text => /#{@version2.name}/

      assert_select "ul#version-#{@version2.id}" do
        assert_select "li", :text => /#{@issue3.subject}/
        assert_select "li", :text => /#{@issue4.subject}/
      end

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
      visit_issue_page(@issue1)

      assert_select "a#changelog", :text => /Change log/, :count => 0

      # Url hacking
      visit "/projects/#{@project.to_param}/changelog"
      assert_forbidden
    end
  end
  
end

