require "spec_helper"

describe OpenNlp::SentenceDetector do
  subject { OpenNlp::SentenceDetector }

  let(:model) { OpenNlp::Model::SentenceDetector.new(File.join(FIXTURES_DIR, "en-sent.bin")) }

  describe "initialization" do
    it "should initialize with a valid model" do
      sent_detector = subject.new(model)
      sent_detector.should be_a(subject)
      sent_detector.j_instance.should be_a(subject.java_class)
    end

    it "should raise an ArgumentError without a valid model" do
      lambda { subject.new(nil) }.should raise_error(ArgumentError)
    end
  end

  describe "#detect" do
    let(:sent_detector) { subject.new(model) }

    it "should detect no sentences in an empty string" do
      sentences = sent_detector.detect("")
      sentences.should == []
    end

    it "should detect sentences in a string" do
      sentences = sent_detector.detect("The sky is blue. The Grass is green.")
      sentences.should == ["The sky is blue.", "The Grass is green."]
    end

    it "should raise an ArgumentError for a non-string" do
      lambda { sent_detector.detect(nil) }.should raise_error(ArgumentError)
    end
  end

  describe "#pos_detect" do
    let(:sent_detector) { subject.new(model) }

    it "should detect sentences in a string" do
      sentences = sent_detector.pos_detect("The sky is blue. The Grass is green.")
      sentences.should == [OpenNlp::Util::Span.new(0, 16), OpenNlp::Util::Span.new(17, 36)]
    end

    it "should raise an ArgumentError for a non-string" do
      expect { sent_detector.detect(nil) }.to raise_error(ArgumentError)
    end
  end
end