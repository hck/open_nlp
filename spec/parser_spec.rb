require "spec_helper"

describe OpenNlp::Parser do
  subject { OpenNlp::Parser }
  let(:model) { OpenNlp::Model::Parser.new(File.join(FIXTURES_DIR, "en-parser-chunking.bin")) }
  let(:token_model) { OpenNlp::Model::Tokenizer.new(File.join(FIXTURES_DIR, "en-token.bin")) }

  describe "initialization" do
    it "should initialize a new parser" do
      parser = subject.new(model, token_model)
      parser.should be_a(subject)
    end

    it "should raise an argument error when no model is supplied" do
      lambda { subject.new(nil, nil) }.should raise_error(ArgumentError)
    end

    it "should raise an argument error when no token_model is supplied" do
      lambda { subject.new(model, nil) }.should raise_error(ArgumentError)
    end
  end

  describe "parsing a string" do
    let(:parser) { subject.new(model, token_model) }

    it "should parse an empty string" do
      parser.parse("").should == {}
    end

    it "should parse a sentence" do
      res = parser.parse("The red fox sleeps soundly .")
      res.class.should == OpenNlp::Parser::Parse
    end

    it "should raise an error when not passed a string" do
      lambda { parser.parse(nil) }.should raise_error(ArgumentError)
    end
  end
end