require 'pathname'
js_root = Pathname(Rails.root).join 'public/javascripts'
app_js = Dir[js_root.join('application/*.js').to_s].sort!.map! do |path|
  Pathname(path).relative_path_from(js_root).to_s
end
app_js.unshift 'application'
ActionView::Helpers::AssetTagHelper.register_javascript_expansion :app => app_js
