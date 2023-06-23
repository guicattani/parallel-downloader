# frozen_string_literal: true
class ParallelDownloader
  module Errors
    class UnreadableFile < StandardError; end
    class EmptyFile < StandardError; end
    class FileExtensionNotImplemented < StandardError; end
  end
end
