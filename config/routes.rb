ActionController::Routing::Routes.draw do |map|
  # Map to the singular changelogs so it's backwards compatible with pre-plugin
  # urls that were posted already.
  map.resource :changelogs, :as => 'changelog', :only => [:show], :path_prefix => "projects/:project_id"
end
