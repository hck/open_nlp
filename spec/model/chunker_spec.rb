require 'spec_helper'

RSpec.describe OpenNlp::Model::Chunker do
  let(:model_file_name) { File.join(FIXTURES_DIR, 'en-chunker.bin') }

  it 'accepts a string filename parameter' do
    chunker_model = described_class.new(model_file_name)
    expect(chunker_model.j_model).to be_a(described_class.java_class)
  end

  it 'accepts a java.io.FileInputStream object' do
    file_input_stream = java.io.FileInputStream.new(model_file_name)
    chunker_model = described_class.new(file_input_stream)
    expect(chunker_model.j_model).to be_a(described_class.java_class)
  end

  it 'raises an argument error when nil is passed as a model' do
    expect { described_class.new(nil) }.to raise_error(ArgumentError)
  end
end
