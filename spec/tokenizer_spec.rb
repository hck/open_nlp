require 'spec_helper'

RSpec.describe OpenNlp::Tokenizer do
  let(:model) { OpenNlp::Model::Tokenizer.new(File.join(FIXTURES_DIR, 'en-token.bin')) }
  let(:tokenizer) { described_class.new(model) }

  describe 'initialization' do
    it 'initialize a new tokenizer' do
      expect(tokenizer.j_instance).to be_a(described_class.java_class)
    end

    it 'raises an argument error when no model is specified' do
      expect { subject.new(nil) }.to raise_error(ArgumentError)
    end
  end

  describe 'tokenize a string' do
    it 'tokenizes an empty string' do
      tokens = tokenizer.tokenize('')
      expect(tokens).to eq([])
    end

    it 'tokenizes a sentence' do
      tokens = tokenizer.tokenize('The red fox sleeps soundly.')
      expect(tokens).to eq(['The', 'red', 'fox', 'sleeps', 'soundly', '.'])
    end

    it 'raises an error when nil is passed as an argument' do
      expect { tokenizer.tokenize(nil) }.to raise_error(ArgumentError)
    end

    it 'raises an error when fixnum is passed as an argument' do
      expect { tokenizer.tokenize(111) }.to raise_error(ArgumentError)
    end

    it 'raises an error when array is passed as an argument' do
      expect { tokenizer.tokenize([1, 2]) }.to raise_error(ArgumentError)
    end
  end
end
