module OpenNlp
  class Chunker < Tool
    self.java_class = Java::opennlp.tools.chunker.ChunkerME

    def initialize(model, token_model, pos_model)
      super(model)

      raise ArgumentError, "model must be an OpenNlp::Tokenizer::Model" unless token_model.is_a?(Model::Tokenizer)
      raise ArgumentError, "model must be an OpenNlp::POSTagger::Model" unless pos_model.is_a?(Model::POSTagger)

      @tokenizer = Tokenizer.new(token_model)
      @pos_tagger = POSTagger.new(pos_model)
    end

    def chunk(str)
      raise ArgumentError, "str must be a String" unless str.is_a?(String)

      tokens = @tokenizer.tokenize(str)
      pos_tags = @pos_tagger.tag(tokens).to_ary

      chunks = @j_instance.chunk(tokens.to_java(:String), pos_tags.to_java(:String)).to_ary

      build_chunks(chunks, tokens, pos_tags)
    end

    private
    def build_chunks(chunks, tokens, pos_tags)
      # data[i] = [token, pos_tag, chunk_val]
      data = tokens.zip(pos_tags, chunks)

      data.inject([]) do |acc, val|
        chunk = val[2]
        acc << [{val[0] => val[1]}] if chunk[0] == 'B'
        acc.last << {val[0] => val[1]} if chunk[0] == 'I'

        acc
      end
    end

    def get_last_probabilities
      @j_instance.probs.to_ary
    end
  end
end