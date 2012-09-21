require "spec_helper"

describe OpenNlp::NamedEntityDetector do
  subject { OpenNlp::NamedEntityDetector }

  let(:model) { OpenNlp::Model::NamedEntityDetector.new(File.join(FIXTURES_DIR, "en-ner-time.bin")) }
  
  describe "initialization" do
    it "should initialize with a valid model" do
      ne_detector = subject.new(model)
      ne_detector.should be_a(subject)
    end

    it "should raise an ArgumentError otherwise" do
      lambda { subject.new(nil) }.should raise_error(ArgumentError)
    end
  end

  describe "detection" do
    let(:ne_detector) { subject.new(model) }

    it "should detect nothing in an empty sentence" do
      spans = ne_detector.detect([])
      spans.should be_a(Array)
      spans.length.should == 0
    end

    it "should detect the named entities" do
      spans = ne_detector.detect(["The", "time", "is", "10", ":", "23", "am"])
      spans.should be_a(Array)
      spans[0].should be_a(Java::opennlp.tools.util.Span)
      spans[0].getStart.should == 3
      spans[0].getEnd.should == 7
    end

    it "should raise an error if anything but an array is passed" do
      lambda { ne_detector.detect(nil) }.should raise_error(ArgumentError)
      lambda { ne_detector.detect('str') }.should raise_error(ArgumentError)
      lambda { ne_detector.detect(111) }.should raise_error(ArgumentError)
    end
  end
end
