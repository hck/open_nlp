module OpenNlp
  class Parser < Tool
    def initialize(model, token_model)
      raise ArgumentError, "model must be an OpenNlp::Model" unless model.is_a?(OpenNlp::Model)
      raise ArgumentError, "model must be an OpenNlp::Tokenizer::Model" unless token_model.is_a?(Model::Tokenizer)

      @j_instance = Java::opennlp.tools.parser.ParserFactory.create(model.j_model)

      @tokenizer = Tokenizer.new(token_model)
    end

    def parse(text)
      raise ArgumentError, "str must be a String" unless text.is_a?(String)
      return {} if text.empty?

      parse_obj = Java::opennlp.tools.parser.Parse.new(
        text.to_java(:String),
        Java::opennlp.tools.util.Span.new(0, text.size),
        Java::opennlp.tools.parser.AbstractBottomUpParser::INC_NODE.to_java(:String),
        1.to_java(:Double), # probability ?
        0.to_java(:Integer) # the token index of the head of this parse
      )

      tokens = @tokenizer.tokenize(text)

      tokens.each_with_index do |tok, i|
        start = get_token_offset text, tokens, i

        parse_obj.insert Java::opennlp.tools.parser.Parse.new(
                           text.to_java(:String),
                           Java::opennlp.tools.util.Span.new(start, start + tok.size),
                           Java::opennlp.tools.parser.AbstractBottomUpParser::TOK_NODE.to_java(:String),
                           0.to_java(:Double),
                           i.to_java(:Integer)
                         )
      end

      Parser::Parse.new(@j_instance.parse(parse_obj))
    end

    private
    def get_token_offset(text, tokens, index)
      offset = 0

      for i in (1..index) do
        offset = text.index tokens[i], offset + tokens[i - 1].size
      end if index > 0

      offset
    end
  end
end