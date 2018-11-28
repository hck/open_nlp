module OpenNlp
  class NamedEntityDetector < Tool
    self.java_class = Java::opennlp.tools.namefind.NameFinderME

    # Detects names for provided array of tokens
    #
    # @param [Array<String>] tokens tokens to run name detection on
    # @return [Array<Java::opennlp.tools.util.Span>] names detected
    def detect(tokens)
      raise ArgumentError, 'tokens must be an instance of Array' unless tokens.is_a?(Array)

      j_instance.find(tokens.to_java(:String)).to_ary
    end
  end
end
