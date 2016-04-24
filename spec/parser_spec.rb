require 'spec_helper'

RSpec.describe OpenNlp::Parser do
  let(:model) { OpenNlp::Model::Parser.new(File.join(FIXTURES_DIR, 'en-parser-chunking.bin')) }
  let(:token_model) { OpenNlp::Model::Tokenizer.new(File.join(FIXTURES_DIR, 'en-token.bin')) }
  let(:parser) { described_class.new(model, token_model) }

  describe 'initialization' do
    it 'initializes a new parser' do
      expect(parser.j_instance).to be_a(Java::opennlp.tools.parser.chunking.Parser)
    end

    it 'raises an argument error when no model specified' do
      expect { described_class.new(nil, nil) }.to raise_error(ArgumentError)
    end

    it 'raises an argument error when no token_model is specified' do
      expect { described_class.new(model, nil) }.to raise_error(ArgumentError)
    end
  end

  describe '#parse' do
    it 'parses an empty string' do
      expect(parser.parse('')).to eq({})
    end

    it 'parses a sentence' do
      res = parser.parse('The red fox sleeps soundly .')
      expect(res).to be_a(OpenNlp::Parser::Parse)
    end

    it 'raises an error when nil is passed as an argument' do
      expect { parser.parse(nil) }.to raise_error(ArgumentError)
    end

    it 'raises an error when fixnum is passed as an argument' do
      expect { parser.parse(111) }.to raise_error(ArgumentError)
    end

    it 'raises an error when array is passed as an argument' do
      expect { parser.parse([1, 2]) }.to raise_error(ArgumentError)
    end
  end
end
