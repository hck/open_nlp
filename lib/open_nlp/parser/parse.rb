module OpenNlp
  class Parser::Parse
    include JavaClass

    attr_reader :j_instance

    self.java_class = Java::opennlp.tools.parser.Parse

    def initialize(java_instance)
      raise ArgumentError, "java_instance must be an instance of #{self.class.java_class.name}" unless java_instance.is_a?(self.class.java_class)

      @j_instance = java_instance
    end

    def tree_bank_string
      span, text, type, res = j_instance.getSpan, j_instance.getText, j_instance.getType, ''
      start                 = span.getStart

      res << "(#{type} " if type != Java::opennlp.tools.parser.AbstractBottomUpParser::TOK_NODE

      j_instance.getChildren.each do |child|
        child_span = child.span
        res << text[start..child_span.getStart-1] if start < child_span.getStart
        res << self.class.new(child).tree_bank_string
        start = child_span.getEnd
      end

      res << text[start..span.getEnd-1] if start < span.getEnd
      res << ")" if type != Java::opennlp.tools.parser.AbstractBottomUpParser::TOK_NODE

      res
    end

    def code_tree
      kids = j_instance.getChildren

      kids.each_with_object([]) do |kid, acc|
        data    = { :type => kid.getType, :parent_type => self.j_instance.getType, :token => kid.toString }
        subtree = self.class.new(kid).code_tree
        data[:children] = subtree unless subtree.empty?
        acc << data
      end
    end
  end
end
