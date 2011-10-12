module IssuesHelper

  # Renders an extended HTML/CSS tooltip: includes information on related tasks
  #
  # To use, a trigger div is needed.  This is a div with the class of "tooltip"
  # that contains this method wrapped in a span with the class of "tip"
  #
  #    <div class="tooltip"><%= link_to_issue(issue) %>
  #      <span class="tip"><%= render_issue_tooltip(issue) %></span>
  #    </div>
  #
  def render_extended_issue_tooltip(issue)
    @cached_label_status ||= l(:field_status)
    @cached_label_start_date ||= l(:field_start_date)
    @cached_label_due_date ||= l(:field_due_date)
    @cached_label_assigned_to ||= l(:field_assigned_to)
    @cached_label_priority ||= l(:field_priority)
    @cached_label_project ||= l(:field_project)
    @cached_label_follows ||= l(:label_follows)
    @cached_label_precedes ||= l(:label_precedes)
    @cached_label_delay ||= l(:field_delay)        

    content = link_to_issue(issue) + "<br /><br />" +
      "<strong>#{@cached_label_project}</strong>: #{link_to_project(issue.project)}<br />" +
      "<strong>#{@cached_label_status}</strong>: #{issue.status.name}<br />" +
      "<strong>#{@cached_label_start_date}</strong>: #{format_date(issue.start_date)}<br />" +
      "<strong>#{@cached_label_due_date}</strong>: #{format_date(issue.due_date)}<br />" +
      "<strong>#{@cached_label_assigned_to}</strong>: #{issue.assigned_to}<br />" +
      "<strong>#{@cached_label_priority}</strong>: #{issue.priority.name}"

    unless issue.relations_to.empty?
      content += "<ul>" + issue.relations_to.map do |rel|
        "<li><strong>%s</strong> %s <span class=\"remove\">%s</span>" % [
          l(rel.label_for(issue)),
          link_to_issue(rel.issue_from),
          link_to('remove', {:controller => 'relations', :action => 'destroy', :issue_id => issue, :id => rel})
        ]
      end.join + "</ul>"
    end

    if not issue.relations_to.empty? and not issue.relations_from.empty?
      content << "<hr />"
    end

    unless issue.relations_from.empty?
      content += "<ul>" << issue.relations_from.map do |rel|
        "<li><strong>%s</strong> %s <span class=\"remove\">%s</span>" % [
          l(rel.label_for(issue)),
          link_to_issue(rel.issue_to),
          link_to('remove', { :controller => 'relations', :action => 'remove', :id => 1 })
        ]
      end.join << "</ul>"
    end

    content
  end
end
