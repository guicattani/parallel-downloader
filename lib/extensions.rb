# frozen_string_literal: true

class ParallelDownloader
  module Extensions
    def self.allowed
      %w[apng avif gif jpg jpeg jfif pjpeg pjp png svg webp]
    end
  end
end
