class IndicatorsController < ApplicationController

  def index
    start = Time.now
    @indicators = Indicator.search(search_params[:query])
    Rails.logger.error("Time to search for #{search_params[:query]}: #{ Time.now - start }")
  end

  def show
    start = Time.now
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
    @dashboards = Dashboard.where(user_id: current_user.id)
    @dashboard_item = DashboardItem.new(indicator_id: @indicator.id)

    @filters = filters.reject { |_,f| f.blank? }
    if @filters.any?
      @series = Series.where(indicator_id: @indicator.id).where(@filters)
    else
      @series = Series.where(indicator_id: @indicator.id)
    end
    @values = Value.where(indicator_id: @indicator.id, series_id: @series.ids)

    grouped_values = @values.group_by(&:series_id)

    @data = @series.map do |serie|
      {
        :name => serie.display_name,
        :data => Hash[grouped_values[serie.id].map{ |value| [value.date, value.value] }]
      }
    end

    Rails.logger.info("time to render show: #{ Time.now - start }")
  end


  private

  def filters
    params.fetch(:filter, {}).permit(:geo_code_id, :frequency_id, :unit_id, :gender_id, :race_id, :age_bracket_id, :employment_status_id, :education_level_id, :child_status_id, :income_level_id, :occupation_code_id, :industry_code_id)
  end

  def search_params
    params.fetch(:search, {}).permit(:query)
  end

end