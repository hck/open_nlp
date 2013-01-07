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
      span = j_instance.get_span
      text = j_instance.get_text
      type = j_instance.get_type
      start = span.get_start

      res = ''

      res << "(#{type} " unless type == Java::opennlp.tools.parser.AbstractBottomUpParser::TOK_NODE

      j_instance.get_children.each do |c|
        s = c.span
        res << text[start..s.get_start-1] if start < s.get_start

        subtree = self.class.new(c).tree_bank_string
        res << subtree if subtree
        start = s.get_end
      end

      res << text[start..span.get_end-1] if start < span.get_end

      res << ")" unless type == Java::opennlp.tools.parser.AbstractBottomUpParser::TOK_NODE

      res
    end

    def code_tree
      j_instance.get_children.each_with_object([]) do |kid, acc|
        data = {:type => kid.get_type, :parent_type => self.j_instance.get_type, :token => kid.to_s}
        subtree = self.class.new(kid).code_tree
        data[:children] = subtree unless subtree.empty?
        acc << data
      end
    end
  end
end