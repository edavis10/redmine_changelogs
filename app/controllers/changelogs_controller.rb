class ChangelogsController < ApplicationController
  unloadable

  menu_item :issues

  before_filter :find_project_by_project_id
  before_filter :authorize

  helper :projects
  
  def show
    @trackers = @project.trackers.find(:all, :conditions => ["is_in_chlog=?", true], :order => 'position')
    retrieve_selected_tracker_ids(@trackers)
    @with_subprojects = params[:with_subprojects].nil? ? Setting.display_subprojects_issues? : (params[:with_subprojects] == '1')
    project_ids = @with_subprojects ? @project.self_and_descendants.collect(&:id) : [@project.id]
    
    @versions = @project.shared_versions.sort
    
    @issues_by_version = {}
    unless @selected_tracker_ids.empty?
      @versions.each do |version|
        conditions = {:tracker_id => @selected_tracker_ids, "#{IssueStatus.table_name}.is_closed" => true}
        if !@project.versions.include?(version)
          conditions.merge!(:project_id => project_ids)
        end
        issues = version.fixed_issues.visible.find(:all,
                                                   :include => [:status, :tracker, :priority],
                                                   :conditions => conditions,
                                                   :order => "#{Tracker.table_name}.position, #{Issue.table_name}.id")
        @issues_by_version[version] = issues
      end
    end
    @versions.reject! {|version| !project_ids.include?(version.project_id) && @issues_by_version[version].empty?}
  end

  private
  
  def retrieve_selected_tracker_ids(selectable_trackers, default_trackers=nil)
    if ids = params[:tracker_ids]
      @selected_tracker_ids = (ids.is_a? Array) ? ids.collect { |id| id.to_i.to_s } : ids.split('/').collect { |id| id.to_i.to_s }
    else
      @selected_tracker_ids = selectable_trackers.collect {|t| t.id.to_s }
    end
  end
end
