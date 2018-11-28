require 'spec_helper'

RSpec.describe OpenNlp::POSTagger do
  let(:model) { OpenNlp::Model::POSTagger.new(File.join(FIXTURES_DIR, 'en-pos-maxent.bin')) }
  let(:pos_tagger) { described_class.new(model) }

  describe 'initialization' do
    it 'initialize with a valid model' do
      expect(pos_tagger.j_instance).to be_a(described_class.java_class)
    end

    it 'raises an ArgumentError without a valid model' do
      expect { described_class.new(nil) }.to raise_error(ArgumentError)
    end
  end

  describe '#tag' do
    it 'tags parts of a provided document' do
      tagged = pos_tagger.tag('The quick brown fox jumps over the lazy dog.')
      expect(tagged).to eq('The/DT quick/JJ brown/JJ fox/NN jumps/NNS over/IN the/DT lazy/JJ dog./NN')
    end

    it 'tags provided tokens' do
      tagged = pos_tagger.tag(%w[The quick brown fox jumps over the lazy dog .])
      expect(tagged.to_ary).to eq(%w[DT JJ JJ NN NNS IN DT JJ NN .])
    end

    it 'raises an ArgumentError when nil is passed as an argument' do
      expect { pos_tagger.tag(nil) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError when fixnum is passed as an argument' do
      expect { pos_tagger.tag(111) }.to raise_error(ArgumentError)
    end
  end
end
