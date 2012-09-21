module OpenNlp
  class Tokenizer < Tool
    self.java_class = Java::opennlp.tools.tokenize.TokenizerME

    def tokenize(str)
      raise ArgumentError, "str must be a String" unless str.is_a?(String)
      @j_instance.tokenize(str).to_ary
    end
  end
end
