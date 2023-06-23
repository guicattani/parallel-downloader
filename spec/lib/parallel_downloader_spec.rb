# rubocop:disable RSpec/MessageSpies
# frozen_string_literal: true

require "spec_helper"

RSpec.describe ParallelDownloader do
  let(:file_name)           { nil }
  let(:separator)           { nil }
  let(:number_of_processes) { nil }
  let(:forceful)            { nil }

  let!(:parallel_downloader) do
    described_class.new(file_name,
                        File.new(File::NULL, "w"),
                        { separator:, number_of_processes:, forceful: })
  end

  describe 'validations and default values' do
    context 'when file extension not implemented' do
      let!(:file_name) { './text.unknown' }

      it 'raises an error' do
        expect { parallel_downloader.exec }.to raise_error(
          ParallelDownloader::Errors::FileExtensionNotImplemented
        )
      end
    end

    context 'when file is not found' do
      let!(:file_name) { 'text.txt' }

      it 'raises an error' do
        expect { parallel_downloader.exec }.to raise_error(ParallelDownloader::Errors::FileNotFound)
      end
    end

    describe 'arguments' do
      let!(:file_name) { 'text.txt' }

      context 'when nothing is given' do
        it 'sets separator blank space' do
          expect(parallel_downloader.separator).to eq(' ')
        end

        it 'sets number of processes to 3' do
          expect(parallel_downloader.number_of_processes).to eq(3)
        end

        it 'sets forceful to false' do
          expect(parallel_downloader.forceful).to eq(false)
        end
      end
    end
  end

  context 'when successful' do
    let!(:file_name) { './spec/fixtures/test comma.txt' }
    let!(:separator) { ',' }

    before { silence_output }
    after { enable_output }

    it 'downloads file from given document', :vcr do
      parallel_downloader.exec
      expect(Dir["#{Dir.pwd}/**.png"].count).to eq(2)

      Dir["#{Dir.pwd}/**.png"].each do |file|
        File.delete(file)
      end

    end
  end

  context 'when errors' do
    let!(:file_name) { './spec/fixtures/test comma error.txt' }
    let!(:separator) { ',' }

    before { silence_output }
    after { enable_output }

    it 'downloads only files with allowed extensions', :vcr do
      parallel_downloader.exec
      expect(Dir["#{Dir.pwd}/**.png"].count).to eq(1)

      Dir["#{Dir.pwd}/**.png"].each do |file|
        File.delete(file)
      end

    end
  end
end

# rubocop:enable RSpec/MessageSpies
