# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name                  = "parallel_downloader"
  spec.version               = "0.0.1"
  spec.required_ruby_version = "3.2.2"
  spec.platform              = Gem::Platform::RUBY
  spec.summary               = "Parallelized Downloader using Parallel Gem and modern Ruby features"
  spec.authors               = ["Guilherme Cattani"]
  spec.email                 = ["gcattani1@gmail.com"]
  spec.homepage              = "http://rubygems.org/gems/pagekey"
  spec.license               = "MPL-2.0"
  spec.files                 = Dir.glob("{lib,bin}/**/*")
  spec.require_path          = "lib"
  spec.executables           = ["parallel_downloader"]
end
