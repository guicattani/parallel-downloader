# frozen_string_literal: true

class ParallelDownloader
  module Helpers
    def self.relative_path_to_absolute(filename)
      "#{Dir.pwd}/#{filename.delete_prefix('./')}"
    end

    def self.get_file_name_from_url(url)
      match = url.match(%r{.*/(.*)\..*\z})
      return match[1] if match

      raise ParallelDownloader::Errors::FileNotFound
    end

    def self.get_file_extension_from_url(path)
      match = path.match(%r{/.*\.(.*)\z})
      return match[1] if match

      raise ParallelDownloader::Errors::FileNotFound
    end

    def self.get_file_extension(path)
      match = path.match(/.*\.(.*)\z/)
      return match[1] if match

      raise ParallelDownloader::Errors::FileNotFound
    end
  end
end
