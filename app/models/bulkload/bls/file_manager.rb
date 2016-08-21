require 'open-uri'
require 'fileutils'
require 'csv'

class Bulkload::Bls::FileManager
  SOURCE = "BLS"

  attr_accessor :obj, :dept, :filename

  def initialize(obj, dept, filename)
    @obj = obj
    @dept = dept
    @filename = filename
  end

  def url
    @url ||= SystemConfig.instance.services.bls.url
  end

  def storage
    @storage ||= SystemConfig.instance.services.bls.storage
  end

  def parsed_file
    @parsed_file ||= parse_file
  end

  def parse_file
    path = download_file
    file = CSV.read(path, { :col_sep => "\t" })
    file.shift
    file
  end

  def download_file
    FileUtils.mkdir_p("#{ storage }/#{ SOURCE }/#{ obj }/#{ dept }")
    path = "#{ storage }/#{ SOURCE }/#{ obj }/#{ dept }/#{ filename }.txt"
    file = File.new(path, "w")
    download = open(url+'/'+dept+'/'+filename)
    IO.copy_stream(download, file)
    file.close
    path
  end
end
