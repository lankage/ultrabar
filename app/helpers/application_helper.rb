module ApplicationHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def sortable(column, title = nil, params_hash=nil)
    title ||= column.titleize
    icon = ""
    if column == sort_column
      if sort_direction=='asc'
        icon = " <i class='glyphicon glyphicon-triangle-top'/>"
      else
        icon = " <i class='glyphicon glyphicon-triangle-bottom'/>"
      end
    end

    search = params[:search]
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to (title+icon).html_safe, { search: search, sort: column, direction: direction}, style: 'color: white;white-space: nowrap'
  end

end
