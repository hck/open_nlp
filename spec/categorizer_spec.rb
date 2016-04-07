require 'spec_helper'

RSpec.describe OpenNlp::Categorizer do
  let(:model) { OpenNlp::Model::Categorizer.new(File.join(FIXTURES_DIR, 'en-doccat.bin')) }

  describe 'initialization' do
    it 'is initialized with a valid model' do
      categorizer = described_class.new(model)
      expect(categorizer.j_instance).to be_a(described_class.java_class)
    end

    it 'raises an ArgumentError without a valid model' do
      expect { described_class.new(nil) }.to raise_error(ArgumentError)
    end
  end

  describe '#categorize' do
    let(:categorizer) { described_class.new(model) }

    it 'categorizes a provided document to positive' do
      category = categorizer.categorize('The fox is a good worker.')
      expect(category).to eq('Positive')
    end

    it 'categorizes a provided document to negative' do
      category = categorizer.categorize('Quick brown fox jumps very bad.')
      expect(category).to eq('Negative')
    end

    it 'raises an ArgumentError when nil is passed as a param' do
      expect { categorizer.categorize(nil) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError when Fixnum is passed a param' do
      expect { categorizer.categorize(123) }.to raise_error(ArgumentError)
    end
  end
end
