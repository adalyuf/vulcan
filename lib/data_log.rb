require 'fileutils'

class DataLog
  SEPARATOR = "\x02"

  class_attribute :last_rotate_time

  def initialize(filename, dir=nil)
    @host_and_separator = {}
    dir ||= File.join(Rails.root, 'log', 'data')
    @path = File.join(dir, filename)
  end

  def log(*columns)
    unless columns.empty?
      message = Time.now.to_f.to_s
      message << "#{SEPARATOR}#{hostname}"

      columns.each do |column|
        message << SEPARATOR

        if column.nil?
        elsif column.acts_like?(:time)
          message << column.to_f.to_s
        elsif column.is_a?(Hash)
          message << column.to_query
        elsif column.is_a?(String)
          message << column.gsub(/([\x02\n])/, ?\002 => ' ', ?\n => "\\n")
        else
          message << column.to_s
        end
      end

      get_log.write message << "\n"
    end
  end

  @@hostname = nil
  def self.hostname
    @@hostname ||= Socket.gethostname.split('.').first
  end

  def hostname
    self.class.hostname
  end

  protected

  def get_log
    if @log && DataLog.last_rotate_time && (@last_open_time < DataLog.last_rotate_time)
      Rails.logger.info "reopening #{@path}"
      @log.try(:close) rescue IOError
      @log = nil
    end

    @log ||= open_log(@path, (File::WRONLY | File::APPEND))
  end

  def open_log(log, mode)
    dir = File.dirname log
    FileUtils.mkdir_p(dir) unless File.exist?(dir)
    FileUtils.touch log
    File.open(log, mode).tap do |log|
      log.set_encoding(Encoding::BINARY) if log.respond_to?(:set_encoding)
      log.sync = true
      @last_open_time = Time.now
    end
  end
end
