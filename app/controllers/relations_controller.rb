class RelationsController < ApplicationController
  unloadable
  before_filter :find_issue

  def new
    @relation = IssueRelation.new(params[:relation])
    @relation.issue_from = @issue
    @relation.issue_to = Issue.visible.find_by_id(params[:relation][:issue_to_id])
    @relation.save if request.post?
    redirect_to :controller => 'gantts', :action => 'show', :project_id => @issue.project
  end

  def destroy
    relation = IssueRelation.find(params[:id])
    if @issue.relations.include?(relation)
      relation.destroy
      @issue.reload
    end

    redirect_to :controller => 'gantts', :action => 'show', :project_id => @issue.project
  end
  
private
  def find_issue
    @issue = Issue.find(params[:issue_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
