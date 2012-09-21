module OpenNlp
  class POSTagger < Tool
    self.java_class = Java::opennlp.tools.postag.POSTaggerME

    def tag(tokens)
      raise ArgumentError, "tokens must be an instance of String or Array" unless (tokens.is_a?(Array) || tokens.is_a?(String))
      @j_instance.tag(tokens.to_java(:String))
    end
  end
end
