module RedmineChangelogs
  module Hooks
    class ViewIssuesSidebarIssuesBottomHook < Redmine::Hook::ViewListener
      def view_issues_sidebar_issues_bottom(context={})
        if context[:project] && User.current.allowed_to?(:view_issue_changelogs, context[:project])
          return link_to(l(:label_change_log), {:controller => 'changelogs', :action => 'show', :project_id => context[:project]}, {:id => 'changelog'}) + "<br />"
        end

      end
    end
  end
end
