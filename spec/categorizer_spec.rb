require 'spec_helper'

describe OpenNlp::Categorizer do
  subject { OpenNlp::Categorizer }
  let(:model){ OpenNlp::Model::Categorizer.new(File.join(FIXTURES_DIR, "en-doccat.bin")) }

  describe "initialization" do
    it "should initialize with a valid model" do
      categorizer = subject.new(model)
      categorizer.should be_a(subject)
      categorizer.j_instance.should be_a(subject.java_class)
    end

    it "should raise an ArgumentError without a valid model" do
      lambda { subject.new(nil) }.should raise_error(ArgumentError)
    end
  end

  describe "categorizing a string" do
    let(:categorizer) { subject.new(model) }

    it "should categorize a provided document to positive" do
      category = categorizer.categorize("The fox is a good worker.")
      category.should == "Positive"
    end

    it "should categorize a provided document to negative" do
      category = categorizer.categorize("Quick brown fox jumps very bad.")
      category.should == "Negative"
    end

    it "should raise an ArgumentError for a non-string" do
      lambda { categorizer.categorize(nil) }.should raise_error(ArgumentError)
    end
  end
end