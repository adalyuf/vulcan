crumb :root do
  link "Home", root_path
end

crumb :categories do
  link "Categories", categories_path
end

crumb :indicators do
  link "Search for Indicators", indicators_path
  parent :categories
end

crumb :category do |category|
  link category.name, category_path(category.internal_name)
  parent :categories
end

crumb :dataset do |dataset|
  link dataset.name, dataset_path(dataset.internal_name)
  parent dataset.category
end

crumb :indicator do |indicator|
  link indicator.name, indicator_path(indicator.dataset.internal_name,indicator.internal_name)
  parent indicator.dataset
end

crumb :series do |series|
  link series.display_name, series_path(series.id)
  parent series.indicator
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).