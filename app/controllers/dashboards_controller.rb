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
    @indicators = Dashboard.find(params[:id]).dashboard_items.reject(&:series_id)
    @indicators = Kaminari.paginate_array(@indicators).page(params[:page]).per(2)
    @series = Dashboard.find(params[:id]).dashboard_items.select(&:series_id)
    @series = Kaminari.paginate_array(@series).page(params[:page]).per(2)
    @indicators_active = (active_tab == 'indicators') ? 'active' : nil
    @series_active = (active_tab == 'series') ? 'active' : nil
  end

  def index
    @dashboards = current_user.dashboards
  end

private

  def dashboard_params
    params.require(:dashboard).permit(:name)
  end

  def active_tab
    params[:toggle] ? params[:toggle] : 'indicators'
  end

end