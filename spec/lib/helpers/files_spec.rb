# rubocop:disable RSpec/MessageSpies
# frozen_string_literal: true

require "spec_helper"

RSpec.describe ParallelDownloader::Helpers do
  describe '#relative_path_to_absolute' do
    it 'adds the current path to working directory in relative path' do
      expect(
        described_class.relative_path_to_absolute('./spec/fixtures/test comma.txt')
      ).to eq("#{Dir.pwd}/spec/fixtures/test comma.txt")
    end
  end
  describe '#get_file_name_from_url' do
    it 'returns the filename from an url' do
      expect(
        described_class.get_file_name_from_url('www.test.com/image.png')
      ).to eq("image")
    end

    it 'raises ParallelDownloader::Errors::FileNotFound if file not found' do
      expect{
        described_class.get_file_name_from_url('www.test.com')
      }.to raise_error(ParallelDownloader::Errors::FileNotFound)
    end
  end
  describe '#get_file_extension_from_url' do
    it 'returns the filename from an url' do
      expect(
        described_class.get_file_extension_from_url('www.test.com/image.png')
      ).to eq("png")
    end

    it 'raises ParallelDownloader::Errors::FileNotFound if file not found' do
      expect{
        described_class.get_file_extension_from_url('www.test.com/image')
      }.to raise_error(ParallelDownloader::Errors::FileNotFound)
    end
  end
  describe '#get_file_extension' do
    it 'returns the filename from a file' do
      expect(
        described_class.get_file_extension('image.png')
      ).to eq("png")
    end

    it 'raises ParallelDownloader::Errors::FileNotFound if file not found' do
      expect{
        described_class.get_file_extension('image')
      }.to raise_error(ParallelDownloader::Errors::FileNotFound)
    end
  end
end