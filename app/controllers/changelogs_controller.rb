class ChangelogsController < ApplicationController
  unloadable

  before_filter :find_project_by_project_id
  before_filter :authorize
  
  def show
  end
end
