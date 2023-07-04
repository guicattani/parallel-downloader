# frozen_string_literal: true

require "parallel"
require "httparty"
require_relative "errors"
require_relative "extensions"
require_relative "helpers"
require_relative "file_readers"

class ParallelDownloader
  attr_reader :file_name, :extension, :logger, :separator, :number_of_processes, :forceful

  def initialize(file_name, logger, args = {})
    @file_name           = file_name
    @extension           = ParallelDownloader::Helpers.get_file_extension(file_name)
    @logger              = logger
    @separator           = args[:separator]           || " "
    @number_of_processes = args[:number_of_processes] || 3
    @forceful            = args[:forceful]            || false
  end

  def exec
    if @file_name.start_with?("./")
      @file_name = ParallelDownloader::Helpers.relative_path_to_absolute(@file_name)
    end

    case @extension
    when 'txt'
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
    download_file_name = ParallelDownloader::Helpers.get_file_name_from_url(url).freeze
    extension = ParallelDownloader::Helpers.get_file_extension_from_url(url).freeze

    file_path = file_path_from_extension(download_file_name, extension)
    if file_path.nil?
      @logger.write(
        "ERROR: Skipped #{download_file_name} from baseurl: #{url} BECAUSE EXTENSION IS FORBIDDEN\n"
      )
      return
    end

    request = nil
    File.open(file_path, "w") do |file|
      file.binmode
      request = HTTParty.get(url, stream_body: true) do |fragment|
        file.write(fragment)
      end
    end
    log_request(request, download_file_name, url)

  rescue Errno::ENOENT
    log_request(request, download_file_name, url)
  end

  def valid_extension?(extension)
    @forceful || ParallelDownloader::Extensions.allowed.include?(extension)
  end

  def file_path_from_extension(download_file_name, extension)
    file_path = nil
    if extension && valid_extension?(extension)
      file_path = "#{Dir.pwd}/#{download_file_name}.#{extension}"
    elsif @forceful
      file_path = "#{Dir.pwd}/#{download_file_name}"
    end

    file_path
  end

  def log_request(request, download_file_name, url)
    if request&.success?
      @logger.write("SUCCESS: Wrote #{download_file_name} from baseurl: #{url}\n")
    elsif !extension
      @logger.write("WARNING: Wrote #{download_file_name} from baseurl: #{url} \
BUT FILE HAS NO EXTENSION\n")
    else
      @logger.write("ERROR: Failed to write #{download_file_name} from baseurl: #{url}\n")
    end
  end
end
