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
      tokens.zip(pos_tags, chunks).each_with_object([]) do |(token, pos_tag, chunk), acc|
        label = chunk[0]
        if label == ?B || acc.empty? # add token to new chunk if no chunks exists or it is a start of chunk
          acc << [{token => pos_tag}]
        elsif label == ?I
          acc.last << {token => pos_tag} # add token to chunk if it is a continuation of chunk
        end
      end
    end
  end
end
