class DashboardItemsController < ApplicationController

  def create
    @dashboard_item = DashboardItem.new(dashboard_item_params)
    @dashboard_item.user_id = current_user.id
    if @dashboard_item.save
      redirect_to @dashboard_item.dashboard
    else
      flash[:error] = @dashboard_item.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

private

  def dashboard_item_params
    params.require(:dashboard_item).permit(:dashboard_id, :indicator_id, :series_id)
  end

end