module OpenNlp
  class POSTagger < Tool
    self.java_class = Java::opennlp.tools.postag.POSTaggerME

    # Adds tags to tokens passed as argument
    #
    # @param [Array<String>, String] tokens tokens to tag
    # @return [Array<String>, String] array of part-of-speech tags or string with added part-of-speech tags
    def tag(tokens)
      !tokens.is_a?(Array) && !tokens.is_a?(String) &&
        raise(ArgumentError, 'tokens must be an instance of String or Array')

      j_instance.tag(tokens.to_java(:String))
    end
  end
end
