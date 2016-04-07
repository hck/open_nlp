require 'spec_helper'

RSpec.describe OpenNlp::SentenceDetector do
  let(:model) { OpenNlp::Model::SentenceDetector.new(File.join(FIXTURES_DIR, 'en-sent.bin')) }
  let(:sentence_detector) { described_class.new(model) }

  describe 'initialization' do
    it 'initializes with a valid model' do
      expect(sentence_detector.j_instance).to be_a(described_class.java_class)
    end

    it 'raises an ArgumentError without a valid model' do
      expect { subject.new(nil) }.to raise_error(ArgumentError)
    end
  end

  describe '#detect' do
    it 'detects no sentences in an empty string' do
      sentences = sentence_detector.detect('')
      expect(sentences).to eq([])
    end

    it 'detects sentences in a string' do
      sentences = sentence_detector.detect('The sky is blue. The Grass is green.')
      expect(sentences).to eq(['The sky is blue.', 'The Grass is green.'])
    end

    it 'raises an ArgumentError when nil is passed as an argument' do
      expect { sentence_detector.detect(nil) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError when fixnum is passed as an argument' do
      expect { sentence_detector.detect(111) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError when array is passed as an argument' do
      expect { sentence_detector.detect([1, 2]) }.to raise_error(ArgumentError)
    end
  end

  describe '#pos_detect' do
    it 'detects sentences in a string' do
      sentences = sentence_detector.pos_detect('The sky is blue. The Grass is green.')
      expect(sentences).to eq([OpenNlp::Util::Span.new(0, 16), OpenNlp::Util::Span.new(17, 36)])
    end

    it 'raises an ArgumentError when nil is passed as an argument' do
      expect { sentence_detector.pos_detect(nil) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError when fixnum is passed as an argument' do
      expect { sentence_detector.pos_detect(111) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError when array is passed as an argument' do
      expect { sentence_detector.pos_detect([1, 2]) }.to raise_error(ArgumentError)
    end
  end
end
