require "spec_helper"

describe OpenNlp::Model::Chunker do
  subject { OpenNlp::Model::Chunker }
  let(:model_file_name) { File.join(FIXTURES_DIR, "en-chunker.bin") }

  it "should accept a string filename parameter" do
    chunker_model = subject.new(model_file_name)
    chunker_model.should be_a(subject)
    chunker_model.j_model.should be_a(subject.java_class_name)
  end

  it "should accept a java.io.FileInputStream object" do
    file_input_stream = java.io.FileInputStream.new(model_file_name)
    chunker_model = subject.new(file_input_stream)
    chunker_model.should be_a(subject)
    chunker_model.j_model.should be_a(subject.java_class_name)
  end

  it "should raise an argument error otherwise" do
    lambda { subject.new(nil) }.should raise_error(ArgumentError)
  end
end