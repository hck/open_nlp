require 'spec_helper'

RSpec.describe OpenNlp::Parser::Parse do
  let(:text) { 'The red fox sleeps soundly .' }
  let(:model) { OpenNlp::Model::Parser.new(File.join(FIXTURES_DIR, 'en-parser-chunking.bin')) }
  let(:token_model) { OpenNlp::Model::Tokenizer.new(File.join(FIXTURES_DIR, 'en-token.bin')) }
  let(:parser) { OpenNlp::Parser.new(model, token_model) }

  describe 'initialization' do
    it 'initializes a new parse object' do
      j_parse = Java::opennlp.tools.parser.Parse.new(
        text.to_java(:String),
        Java::opennlp.tools.util.Span.new(0, text.size),
        Java::opennlp.tools.parser.AbstractBottomUpParser::INC_NODE.to_java(:String),
        1.to_java(:Double),
        0.to_java(:Integer)
      )

      parse = described_class.new(j_parse)
      expect(parse.j_instance).to be_a(described_class.java_class)
    end

    it 'raises an argument error when nil is passed as an argumenr' do
      expect { described_class.new(nil) }.to raise_error(ArgumentError)
    end
  end

  describe '#tree_bank_string' do
    let(:expected_tree_bank_str) do
      '(TOP (S (NP (DT The) (JJ red) (NN fox)) (VP (VBZ sleeps) (ADVP (RB soundly))) (. .)))'
    end

    it 'returns proper string value for parsed text' do
      tree_bank_string = parser.parse(text).tree_bank_string
      expect(tree_bank_string).to eq(expected_tree_bank_str)
    end
  end

  describe '#code_tree' do
    let(:expected_code_tree) do
      [
        {
          :type => 'S',
          :parent_type => 'TOP',
          :token => 'The red fox sleeps soundly .',
          :children => [
            {
              :type => 'NP',
              :parent_type => 'S',
              :token => 'The red fox',
              :children => [
                {
                    :type => 'DT',
                    :parent_type => 'NP',
                    :token => 'The',
                    :children => [{:type => 'TK', :parent_type => 'DT', :token => 'The'}]
                },
                {
                    :type => 'JJ',
                    :parent_type => 'NP',
                    :token => 'red',
                    :children => [{:type => 'TK', :parent_type => 'JJ', :token => 'red'}]
                },
                {
                    :type => 'NN',
                    :parent_type => 'NP',
                    :token => 'fox',
                    :children => [{:type => 'TK', :parent_type => 'NN', :token => 'fox'}]
                }
              ]
            },
            {
              :type => 'VP',
              :parent_type => 'S',
              :token => 'sleeps soundly',
              :children => [
                {
                  :type => 'VBZ',
                  :parent_type => 'VP',
                  :token => 'sleeps',
                  :children => [{:type => 'TK', :parent_type => 'VBZ', :token => 'sleeps'}]
                },
                {
                  :type => 'ADVP',
                  :parent_type => 'VP',
                  :token => 'soundly',
                  :children => [
                    {
                      :type => 'RB',
                      :parent_type => 'ADVP',
                      :token => 'soundly',
                      :children => [{:type => 'TK', :parent_type => 'RB', :token => 'soundly'}]
                    }
                  ]
                }
              ]
            },
            {
              :type => '.',
              :parent_type => 'S',
              :token => '.',
              :children => [{:type => 'TK', :parent_type => '.', :token => '.'}]
            }
          ]
        }
      ]
    end

    it 'returns proper structure for parsed text' do
      code_tree = parser.parse(text).code_tree
      expect(code_tree).to eq(expected_code_tree)
    end
  end
end
