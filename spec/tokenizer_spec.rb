require "spec_helper"

describe OpenNlp::Tokenizer do
  subject { OpenNlp::Tokenizer }

  let(:model) { OpenNlp::Model::Tokenizer.new(File.join(FIXTURES_DIR, "en-token.bin")) }

  describe "initialization" do
    it "should initialize a new tokenizer" do
      tokenizer = subject.new(model)
      tokenizer.should be_a(subject)
    end

    it "should raise an argument error when no model is supplied" do
      lambda { subject.new(nil) }.should raise_error(ArgumentError)
    end
  end

  describe "tokenize a string" do
    let(:tokenizer) { subject.new(model) }

    it "should tokenize an empty string" do
      tokens = tokenizer.tokenize("")
      tokens.should == []
    end

    it "should tokenize a sentence" do
      tokens = tokenizer.tokenize("The red fox sleeps soundly.")
      tokens.should == ["The", "red", "fox", "sleeps", "soundly", "."]
    end

    it "should raise an error when not passed a string" do
      lambda { tokenizer.tokenize(nil) }.should raise_error(ArgumentError)
    end
  end
end