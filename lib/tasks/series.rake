namespace :series do

  desc "update min/max dates for each series"
  task :update_dates => :environment do
    start = Time.now
    Rails.logger.error("We have begun updating the min/max dates of every series, as of: #{start}")

    Indicator.all.each do |ind|
      values = Value.connection.select_all("select series_id, min(date), max(date) from values_partitions.p#{ind.id} group by series_id")
      values.rows.each do |row|
        ser = Series.find(row[0])
        ser.min_date = row[1]
        ser.max_date = row[2]
        ser.save
      end
    end

    elapsed = Time.now - start
    minutes = elapsed.to_i/60
    seconds = elapsed%60
    Rails.logger.error("Time to update dates: #{ elapsed } seconds, aka #{minutes} minutes and #{seconds} seconds")
  end

end