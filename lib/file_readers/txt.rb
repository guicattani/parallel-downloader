# frozen_string_literal: true

class ParallelDownloader
  module FileReader
    module Txt
      def self.read(filename, separator)
        raise ParallelDownloader::Errors::FileNotFound unless File.exist?(filename)

        lines = File.read(filename)
        raise ParallelDownloader::Errors::EmptyFile if lines.empty?

        lines = lines.split(separator)
        lines.map(&:strip)
      end
    end
  end
end
