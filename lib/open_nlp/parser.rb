module OpenNlp
  class Parser < Tool
    # Initializes new instance of Parser
    #
    # @param [OpenNlp::Model::Parser] parser_model
    # @param [OpenNlp::Model::Tokenizer] token_model
    def initialize(parser_model, token_model)
      parser_model.is_a?(OpenNlp::Model::Parser) ||
        raise(ArgumentError, 'parser_model must be an OpenNlp::Model')

      token_model.is_a?(Model::Tokenizer) ||
        raise(ArgumentError, 'token_model must be an OpenNlp::Tokenizer::Model')

      @j_instance = Java::opennlp.tools.parser.ParserFactory.create(parser_model.j_model)
      @tokenizer = Tokenizer.new(token_model)
    end

    # Parses text into instance of Parse class
    #
    # @param [String] text text to parse
    # @return [OpenNlp::Parser::Parse]
    def parse(text)
      raise ArgumentError, 'passed text must be a String' unless text.is_a?(String)

      text.empty? ? {} : parse_tokens(tokenizer.tokenize(text), text)
    end

    private

    attr_reader :tokenizer

    def get_token_offset(text, tokens, index)
      return 0 if index.zero?

      (1..index).inject(0) do |offset, i|
        text.index(tokens[i], offset + tokens[i - 1].size)
      end
    end

    def build_parse_obj(text, span_start, span_end, type = Java::opennlp.tools.parser.AbstractBottomUpParser::INC_NODE, probability = 1, token_index = 0)
      Java::opennlp.tools.parser.Parse.new(
        text.to_java(:String),
        Java::opennlp.tools.util.Span.new(span_start, span_end),
        type.to_java(:String),
        probability.to_java(:Double), # probability ?
        token_index.to_java(:Integer) # the token index of the head of this parse
      )
    end

    def parse_tokens(tokens, text)
      parse_obj = build_parse_obj(text, 0, text.size)
      parse_type = Java::opennlp.tools.parser.AbstractBottomUpParser::TOK_NODE

      tokens.each_with_index do |tok, i|
        start = get_token_offset(text, tokens, i)
        token_parse = build_parse_obj(text, start, start + tok.size, parse_type, 0, i)
        parse_obj.insert(token_parse)
      end

      Parser::Parse.new(j_instance.parse(parse_obj))
    end
  end
end
