module OpenNlp
  class Categorizer < Tool
    self.java_class = Java::opennlp.tools.doccat.DocumentCategorizerME

    def categorize(str)
      raise ArgumentError, "str must be a String" unless str.is_a?(String)

      outcomes = @j_instance.categorize(str)
      @j_instance.getBestCategory(outcomes)
    end
  end
end