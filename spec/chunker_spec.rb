require 'spec_helper'

RSpec.describe OpenNlp::Chunker do
  let(:model) { OpenNlp::Model::Chunker.new(File.join(FIXTURES_DIR, 'en-chunker.bin')) }
  let(:token_model) { OpenNlp::Model::Tokenizer.new(File.join(FIXTURES_DIR, 'en-token.bin')) }
  let(:pos_model) { OpenNlp::Model::POSTagger.new(File.join(FIXTURES_DIR, 'en-pos-maxent.bin')) }
  let(:chunker) { described_class.new(model, token_model, pos_model) }

  describe 'initialization' do
    it 'initializes a new chunker' do
      expect(chunker).to be_a(described_class)
    end

    it 'raises an argument error when no model is specified' do
      expect { subject.new(nil, nil, nil) }.to raise_error(ArgumentError)
    end

    it 'raises an argument error when no token_model is specified' do
      expect { subject.new(model, nil, nil) }.to raise_error(ArgumentError)
    end

    it 'raises an argument error when no pos_model is specified' do
      expect { subject.new(model, token_model, nil) }.to raise_error(ArgumentError)
    end
  end

  describe 'chunking a string' do
    it 'chunks an empty string' do
      chunks = chunker.chunk('')
      expect(chunks).to eq([])
    end

    it 'chunks a sentence' do
      chunks = chunker.chunk('The red fox sleeps soundly.')
      expect(chunks).to eq(
        [
          [{ 'The' => 'DT' }, { 'red' => 'JJ' }, { 'fox' => 'NN' }, { 'sleeps' => 'NNS' }],
          [{ 'soundly' => 'RB' }]
        ]
      )
    end

    it 'raises an error when not passed a string' do
      expect { chunker.chunk(nil) }.to raise_error(ArgumentError)
    end
  end
end
