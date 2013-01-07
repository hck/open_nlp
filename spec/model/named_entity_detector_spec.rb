require "spec_helper"

describe OpenNlp::Model::NamedEntityDetector do
  subject { OpenNlp::Model::NamedEntityDetector }
  let(:model_file_name) { File.join(FIXTURES_DIR, "en-ner-time.bin") }

  it "should accept a string filename parameter" do
    model = subject.new(model_file_name)
    model.should be_a(subject)
    model.j_model.should be_a(subject.java_class)
  end

  it "should accept a Java::JavaIO::FileInputStream object" do
    file_input_stream = Java::JavaIO::FileInputStream.new(model_file_name)
    model = subject.new(file_input_stream)
    model.should be_a(subject)
    model.j_model.should be_a(subject.java_class)
  end

  it "should raise an argument error otherwise" do
    lambda { subject.new(nil) }.should raise_error(ArgumentError)
  end
end
