require "spec_helper"

describe OpenNlp::POSTagger do
  subject { OpenNlp::POSTagger }

  let(:model) { OpenNlp::Model::POSTagger.new(File.join(FIXTURES_DIR, "en-pos-maxent.bin")) }

  describe "initialization" do
    it "should initialize with a valid model" do
      tagger = subject.new(model)
      tagger.should be_a(subject)
      tagger.j_instance.should be_a(subject.java_class)
    end

    it "should raise an ArgumentError without a valid model" do
      lambda { subject.new(nil) }.should raise_error(ArgumentError)
    end
  end

  describe "pos tagging" do
    let(:pos_tagger) { subject.new(model) }

    it "should tag parts of a provided document" do
      tagged = pos_tagger.tag("The quick brown fox jumps over the lazy dog.")
      tagged.should == "The/DT quick/JJ brown/JJ fox/NN jumps/NNS over/IN the/DT lazy/JJ dog./NN"
    end

    it "should tag provided tokens" do
      tagged = pos_tagger.tag(%w(The quick brown fox jumps over the lazy dog .))
      tagged.to_ary.should == %w(DT JJ JJ NN NNS IN DT JJ NN .)
    end

    it "should raise an ArgumentError for a non-string" do
      lambda { pos_tagger.tag(nil) }.should raise_error(ArgumentError)
    end
  end
end