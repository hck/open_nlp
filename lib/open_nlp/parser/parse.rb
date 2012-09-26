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
      span = j_instance.getSpan
      text = j_instance.getText
      type = j_instance.getType
      start = span.getStart

      res = ''

      res << "(#{type} " unless type == Java::opennlp.tools.parser.AbstractBottomUpParser::TOK_NODE

      j_instance.getChildren.each do |c|
        s = c.span
        res << text[start..s.getStart-1] if start < s.getStart

        subtree = self.class.new(c).tree_bank_string
        res << subtree if subtree
        start = s.getEnd
      end

      res << text[start..span.getEnd-1] if start < span.getEnd

      res << ")" unless type == Java::opennlp.tools.parser.AbstractBottomUpParser::TOK_NODE

      res
    end

    def code_tree
      kids = j_instance.getChildren

      kids.inject([]) do |acc,kid|
        data = {type: kid.getType, parent_type: self.j_instance.getType, token: kid.toString}
        subtree = self.class.new(kid).code_tree
        data[:children] = subtree unless subtree.empty?
        acc << data

        acc
      end
    end
  end
end