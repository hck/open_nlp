require "spec_helper"

describe OpenNlp::Model::Detokenizer do
  subject { OpenNlp::Model::Detokenizer }
  let(:model_file_name) { File.join(FIXTURES_DIR, "en-detokenizer.xml") }

  it "should accept a string filename parameter" do
    model = subject.new(model_file_name)
    model.should be_a(subject)
    model.j_model.should be_a(subject.java_class)
  end

  it "should accept a java.io.FileInputStream object" do
    file_input_stream = java.io.FileInputStream.new(model_file_name)
    model = subject.new(file_input_stream)
    model.should be_a(subject)
    model.j_model.should be_a(subject.java_class)
  end

  it "should raise an argument error otherwise" do
    lambda { subject.new(nil) }.should raise_error(ArgumentError)
  end
end
