class IndicatorsController < ApplicationController

  def index
    @query = search_params[:query]
    @indicators = Indicator.search(@query)
    @toggle = @query ? nil : "in"

    @geo_codes = GeoCode.all
    @frequencies = Frequency.all
    @units = Unit.all
    @genders = Gender.all
    @races = Race.all
    @age_brackets = AgeBracket.all
    @employment_statuses = EmploymentStatus.all
    @education_levels = EducationLevel.all
    @child_statuses = ChildStatus.all
    @income_levels = IncomeLevel.all
    @occupation_codes = OccupationCode.all
    @industry_codes = IndustryCode.all

    @filters = filters.reject { |_,f| f.blank? }
    if @filters.any?
      @indicators = Indicator.where(id: Series.select(:indicator_id).where(@filters))
    else
      @indicators = Indicator.search(search_params[:query])
    end
    @indicators = @indicators.select { |indicator| indicator.series.minimum(:min_date) < SystemConfig.trial_scope_end_date } unless current_user
    @indicators = @indicators.page(params[:page])
  end

  def show
    @dataset = Dataset.find_by(internal_name: params[:dataset_internal_name])
    @indicator = Indicator.find_by(dataset_id: @dataset.id, internal_name: params[:internal_name])
    @category = Category.find(@dataset.category_id)

    @geo_codes = GeoCode.all
    @frequencies = Frequency.all
    @units = Unit.all #Unit is always the same for a given indicator, that is how we have defined it...
    @genders = Gender.all
    @races = Race.all
    @age_brackets = AgeBracket.all
    @employment_statuses = EmploymentStatus.all
    @education_levels = EducationLevel.all
    @child_statuses = ChildStatus.all
    @income_levels = IncomeLevel.all
    @occupation_codes = OccupationCode.all
    @industry_codes = IndustryCode.all
    @start_date = start_date || 'Start Date'
    @end_date = end_date || 'End Date'

    @filters = filters.reject { |_,f| f.blank? }
    if @filters.any?
      @series = Series.where(indicator_id: @indicator.id).where(@filters)
    else
      @series = Series.where(indicator_id: @indicator.id)
    end
    @series = @series.order(:name).page(params[:page])

    if current_user
      @dashboards = current_user.dashboards
      @dashboard_item = DashboardItem.new(indicator_id: @indicator.id)
    end

    @data = @series.limit(10).map do |series|
      series.display_data(current_user, start_date, end_date)
    end
  end


  private

  def filters
    params.fetch(:filter, {}).permit(:geo_code_id, :frequency_id, :unit_id, :gender_id, :race_id, :age_bracket_id, :employment_status_id, :education_level_id, :child_status_id, :income_level_id, :occupation_code_id, :industry_code_id)
  end

  def search_params
    params.fetch(:search, {}).permit(:query)
  end

  def dates
    params.fetch(:dates, {}).permit(:start_date, :end_date)
  end

  def start_date
    dates['start_date'] ? dates['start_date'].to_date : nil
  end

  def end_date
    dates['end_date'] ? dates['end_date'].to_date : nil
  end

end