module OpenNlp
  class Categorizer < Tool
    self.java_class = Java::opennlp.tools.doccat.DocumentCategorizerME

    # Categorizes a string passed as parameter to one of the categories
    #
    # @param [String] str string to be categorized
    # @return [String] category
    def categorize(str)
      raise ArgumentError, 'str param must be a String' unless str.is_a?(String)

      outcomes = j_instance.categorize(str)
      j_instance.getBestCategory(outcomes)
    end
  end
end
