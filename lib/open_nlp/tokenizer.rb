module OpenNlp
  class Tokenizer < Tool
    self.java_class = Java::opennlp.tools.tokenize.TokenizerME

    # Tokenizes a string
    #
    # @param [String] str string to tokenize
    # @return [Array] array of string tokens
    def tokenize(str)
      raise ArgumentError, 'str must be a String' unless str.is_a?(String)
      j_instance.tokenize(str).to_ary
    end

    private

    def get_last_probabilities
      j_instance.getTokenProbabilities.to_ary
    end
  end
end
