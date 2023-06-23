# frozen_string_literal: true

class ParallelDownloader
  module Errors
    class InsufficientArguments < StandardError; end
    class UnreadableFile < StandardError; end
    class EmptyFile < StandardError; end
    class FileNotFound < StandardError; end
    class FileExtensionNotImplemented < StandardError; end
  end
end
