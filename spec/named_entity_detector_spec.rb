require 'spec_helper'

RSpec.describe OpenNlp::NamedEntityDetector do
  let(:model) { OpenNlp::Model::NamedEntityDetector.new(File.join(FIXTURES_DIR, 'en-ner-time.bin')) }
  let(:ne_detector) { described_class.new(model) }

  describe 'initialization' do
    it 'initializes with a valid model' do
      expect(ne_detector.j_instance).to be_a(described_class.java_class)
    end

    it 'raises an ArgumentError otherwise' do
      expect { subject.new(nil) }.to raise_error(ArgumentError)
    end
  end

  describe '#detect' do
    it 'detects nothing for empty sentence' do
      spans = ne_detector.detect([])
      expect(spans).to eq([])
    end

    it 'detects the named entities' do
      spans = ne_detector.detect(['The', 'time', 'is', '10', ':', '23', 'am'])
      expect(spans.size).to eq(1)
      expect(spans.first).to be_a(Java::opennlp.tools.util.Span)
      expect(spans.first.getStart).to eq(3)
      expect(spans.first.getEnd).to eq(7)
    end

    it 'raises an error if nil is passed as an argument' do
      expect { ne_detector.detect(nil) }.to raise_error(ArgumentError)
    end

    it 'raises an error if string is passed as an argument' do
      expect { ne_detector.detect('str') }.to raise_error(ArgumentError)
    end

    it 'raises an error if fixnum is passed as an argument' do
      expect { ne_detector.detect(111) }.to raise_error(ArgumentError)
    end
  end
end
