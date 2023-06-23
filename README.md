# Parallel Downloader

This is a test application to download files from multiple urls as efficiently as possible using Ruby

It was created in the form of a gem because it's easier to carry it around and use it in a terminal

It can be improved later by using something like (ruby-packer)[https://github.com/pmq20/ruby-packer] and be compiled in a single executable (to be better used by layman that are not proficient in using a terminal)

# Features
* Very fast processing due to parallelization
* Robust error handling for requests that may fail
* Permission handling with allow list for extensions
* Neat progress bar (using `ruby-progressbar`)
* Easy terminal docs with `--help`
* Easily extensible

# Arguments and flags
* `file_name`: It is mandatory to pass a file, relative and absolute paths are supported
* `-n` : Changes the number of parallel processes processing the requesting
* `-s` : Changes the separator in the file
* `-f` : Forces the crawler to ignore safeguards and bypasses the extension allow list
* `-h` : Shows the help in the terminal


# Testing

Build the gem with `gem build parallel_downloader.gemspec` and then install it with `gem install ./parallel_downloader-0.0.1.gem`. It should become available and work with `parallel_downloader ./spec/fixtures/test\ spaces.txt -n 10 -f`. Testing files are present in `spec/fixtures`