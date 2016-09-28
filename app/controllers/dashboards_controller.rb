class DashboardsController < ApplicationController

  def new
    @dashboard = Dashboard.new
  end

  def create
    @dashboard = Dashboard.new(dashboard_params)
    @dashboard.user_id = current_user.id
    @dashboard.save
    redirect_to @dashboard
  end

  def show
    @dashboard = Dashboard.find(params[:id])
    @indicators = @dashboard.dashboard_items.reject(&:series_id)
    @series = @dashboard.dashboard_items.select(&:series_id)
  end

  def index
    @dashboards = current_user.dashboards
  end

private

  def dashboard_params
    params.require(:dashboard).permit(:name)
  end

end