namespace :series do

  desc "update min/max dates for each series"
  task :update_dates => :environment do
    start = Time.now
    Rails.logger.error("We have begun updating the min/max dates of every series, as of: #{start}")

    Indicator.all.each do |ind|
      values = Value.where(indicator_id: ind.id)
      mins = values.group(:series_id).minimum(:date)
      maxs = values.group(:series_id).maximum(:date)
      ind.series.each do |ser|
        ser.min_date = mins[ser.id]
        ser.max_date = maxs[ser.id]
        ser.save
      end
    end

    elapsed = Time.now - start
    minutes = elapsed.to_i/60
    seconds = elapsed%60
    Rails.logger.error("Time to import values: #{ elapsed } seconds, aka #{minutes} minutes and #{seconds} seconds")
  end

end