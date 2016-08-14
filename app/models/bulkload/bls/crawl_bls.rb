class Bulkload::Bls::CrawlBls

  #Crawl the BLS folder structure and extract files
  require 'Nokogiri'
  require 'open-uri'
  require 'fileutils'

  SOURCE = "BLS"

  def url
    @url ||= SystemConfig.instance.services.bls.url
  end

  def storage
    @storage ||= SystemConfig.instance.services.bls.storage
  end

  #I think this can be completely generalized if the items marked TODO are completed
  def crawl #TODO: (base, source, query, exclusion[])
    folders = get_folders
    links = get_links(folders)
    filtered_links = filter_links(links) #TODO: add exclusion array
    download_files(filtered_links)
  end

  #Each link on this page is a folder, extract each link's value and append to the folders array
  def get_folders
    doc = Nokogiri::HTML(open(url))
    doc.xpath("//@href").map do |url|
      url.value
    end
  end

  #For each folder, open the link and extract all the links
  def get_links(folders)
    folders.map do |folder|
      doc = Nokogiri::HTML( open( URI::join(url,folder) ) )
      doc.xpath("//@href").map do |url|
        url.value
      end
    end.flatten
  end

  #Only the links containing 'data' are ones we are interested in, filter down to these
  def filter_links(links)
    filtered_links = links.map do |link|
        next unless link.include?("data") #TODO: Extract into query parameter
        link
      end.compact

    #TODO: Extract into exclusion array parameter - Could I pull in file size and exclude equal size files?
    filtered_links -= ["/pub/time.series/ch/ch.data.0.Current"] #Duplicate of ch.data.1.AllData - 3.3 GB
    filtered_links -= ["/pub/time.series/cs/cs.data.0.Current"] #Duplicate of cs.data.1.AllData - 3.1 GB

    filtered_links.reject { |link| link =~ /(dataset|datatype|dataelement|dataclass|data.type|data_type|tdata|dataseries)/ }
  end

  def download_files(filtered_links)
    #For testing we will use only the first value of filtered_links
    filtered_links.first(2).each do |link|
    # filtered_links.each do |link|
      reversed = link.reverse
      dir = reversed[reversed.index("/"), reversed.length].reverse
      filename = reversed[0, reversed.index("/")].reverse
      dept = dir["/pub/time.series".length, dir.length] #TODO: Extract into some kind of parameter

      FileUtils.mkdir_p("#{ storage }/#{ SOURCE }/values/#{ dept }")
      path = "#{ storage }/#{ SOURCE }/values/#{ dept }/#{ filename }.txt"
      file = File.new(path, "w")
      download = open(url + dept[1, dept.length] + filename)
      IO.copy_stream(download, file)
      file.close
    end
  end
end