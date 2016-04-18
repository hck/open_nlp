module OpenNlp
  class POSTagger < Tool
    self.java_class = Java::opennlp.tools.postag.POSTaggerME

    # Adds tags to tokens passed as argument
    #
    # @param [Array<String>, String] tokens tokens to tag
    # @return [Array<String>, String] array of part-of-speech tags or string with added part-of-speech tags
    def tag(tokens)
      unless (tokens.is_a?(Array) || tokens.is_a?(String))
        fail ArgumentError, 'tokens must be an instance of String or Array'
      end

      j_instance.tag(tokens.to_java(:String))
    end
  end
end
