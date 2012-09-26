require "spec_helper"

describe OpenNlp::Chunker do
  subject { OpenNlp::Chunker }

  let(:model) { OpenNlp::Model::Chunker.new(File.join(FIXTURES_DIR, "en-chunker.bin")) }
  let(:token_model) { OpenNlp::Model::Tokenizer.new(File.join(FIXTURES_DIR, "en-token.bin")) }
  let(:pos_model) { OpenNlp::Model::POSTagger.new(File.join(FIXTURES_DIR, "en-pos-maxent.bin")) }

  describe "initialization" do
    it "should initialize a new chunker" do
      chunker = subject.new(model, token_model, pos_model)
      chunker.should be_a(subject)
    end

    it "should raise an argument error when no model is supplied" do
      lambda { subject.new(nil, nil, nil) }.should raise_error(ArgumentError)
    end

    it "should raise an argument error when no token_model is supplied" do
      lambda { subject.new(model, nil, nil) }.should raise_error(ArgumentError)
    end

    it "should raise an argument error when no pos_model is supplied" do
      lambda { subject.new(model, token_model, nil) }.should raise_error(ArgumentError)
    end
  end

  describe "chunking a string" do
    let(:chunker) { subject.new(model, token_model, pos_model) }

    it "should chunk an empty string" do
      chunks = chunker.chunk("")
      chunks.should == []
    end

    it "should chunk a sentence" do
      chunks = chunker.chunk("The red fox sleeps soundly.")
      chunks.should == [[{"The"=>"DT"}, {"red"=>"JJ"}, {"fox"=>"NN"}, {"sleeps"=>"NNS"}], [{"soundly"=>"RB"}]]
    end

    it "should raise an error when not passed a string" do
      lambda { chunker.chunk(nil) }.should raise_error(ArgumentError)
    end
  end
end
