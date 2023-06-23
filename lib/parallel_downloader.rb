# frozen_string_literal: true
require "parallel"
require "httparty"

class ParallelDownloader
  attr_accessor :log

  def initialize(file_name, separator = " ", number_of_processes = 3, forceful = false, log)
    @file_name = file_name
    @separator = separator
    @number_of_processes = number_of_processes
    @forceful = forceful
    @log = log
  end

  def exec
    if @file_name.start_with?("./")
      @file_name = ParallelDownloader::Helpers.relative_path_to_absolute(@file_name)
    end

    if @file_name.end_with?(".txt")
      urls = ParallelDownloader::FileReader::Txt.read(@file_name, @separator)
    else
      raise ParallelDownloader::Errors::FileExtensionNotImplemented
    end

    ::Parallel.map(urls.uniq,
                   in_processes: @number_of_processes,
                   progress: "Downloading files") do |url|
      download(url)
    end
  end

  private

  def download(url)
    file_name = ParallelDownloader::Helpers.get_file_name_from_url(url).freeze
    extension = ParallelDownloader::Helpers.get_file_extension_from_url(url).freeze

    if (extension && (@forceful || ParallelDownloader::Extensions.allowed.include?(extension)))
      file_path = "#{Dir.pwd}/#{file_name}.#{extension}"
    elsif (@forceful)
      file_path = "#{Dir.pwd}/#{file_name}"
    else
      return @log.write("ERROR! Skipping #{file_name} from baseurl: #{url}\
BECAUSE EXTENSION IS FORBIDDEN\n")
    end

    request = nil
    File.open(file_path, "w") do |file|
      file.binmode
      request = HTTParty.get(url, stream_body: true) do |fragment|
        file.write(fragment)
      end
    end

    if request && request.success?
      @log.write("SUCCESS: Wrote #{file_name} from baseurl: #{url}\n")
    elsif !extension
      @log.write("WARNING! Wrote #{file_name} from baseurl: #{url}\
BUT FILE HAS NO EXTENSION\n")
    else
      @log.write("ERROR! Failed to write #{file_name} from baseurl: #{url}\n")
    end
  end

end
