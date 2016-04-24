module OpenNlp
  class Chunker < Tool
    self.java_class = Java::opennlp.tools.chunker.ChunkerME

    # Initializes new instance of Chunker
    #
    # @param [OpenNlp::Model] model chunker model
    # @param [Model::Tokenizer] token_model tokenizer model
    # @param [Model::POSTagger] pos_model part-of-speech tagging model
    def initialize(model, token_model, pos_model)
      super(model)

      unless token_model.is_a?(Model::Tokenizer)
        raise ArgumentError, 'token model must be an OpenNlp::Tokenizer::Model'
      end

      unless pos_model.is_a?(Model::POSTagger)
        raise ArgumentError, 'pos model must be an OpenNlp::POSTagger::Model'
      end

      @tokenizer = Tokenizer.new(token_model)
      @pos_tagger = POSTagger.new(pos_model)
    end

    # Chunks a string into part-of-sentence pieces
    #
    # @param [String] str string to chunk
    # @return [Array] array of chunks with part-of-sentence information
    def chunk(str)
      raise ArgumentError, 'str must be a String' unless str.is_a?(String)

      tokens = tokenizer.tokenize(str)
      pos_tags = pos_tagger.tag(tokens).to_ary

      chunks = j_instance.chunk(tokens.to_java(:String), pos_tags.to_java(:String)).to_ary

      build_chunks(chunks, tokens, pos_tags)
    end

    private

    attr_reader :tokenizer, :pos_tagger

    def build_chunks(chunks, tokens, pos_tags)
      data = tokens.zip(pos_tags, chunks)

      data.inject([]) do |acc, val|
        chunk = val[2]
        acc << [{val[0] => val[1]}] if chunk[0] == 'B' # add token to chunk if it is a start of chunk

        if chunk[0] == 'I'
          if acc.last
            acc.last << {val[0] => val[1]} # add token to chunk if it is a continuation of chunk
          else
            acc << [{val[0] => val[1]}] # add token to new chunk if no chunks exists
          end
        end

        acc
      end
    end

    def get_last_probabilities
      j_instance.probs.to_ary
    end
  end
end
