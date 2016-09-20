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
    @dashboard_items = DashboardItem.where(dashboard_id: @dashboard.id)

    @indicators = @dashboard_items.reject(&:series_id)
    @series = @dashboard_items.select(&:series_id)
  end

  def index
    @dashboards = Dashboard.where(user_id: current_user.id)
  end

private

  def dashboard_params
    params.require(:dashboard).permit(:name)
  end

end