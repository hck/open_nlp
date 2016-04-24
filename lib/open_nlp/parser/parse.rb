module OpenNlp
  class Parser::Parse
    include JavaClass

    attr_reader :j_instance

    self.java_class = Java::opennlp.tools.parser.Parse

    # Initializes instance of Parser::Parse
    #
    # @param [Java::opennlp.tools.parser.Parse] java_instance
    def initialize(java_instance)
      unless java_instance.is_a?(self.class.java_class)
        raise ArgumentError, "java_instance must be an instance of #{self.class.java_class.name}"
      end

      @j_instance = java_instance
    end

    # Composes tree bank string, nested string representation of sentence parts, parts-of-speech and words,
    # for example:
    #   '(TOP (S (NP (DT The) (JJ red) (NN fox)) (VP (VBZ sleeps) (ADVP (RB soundly))) (. .)))'
    #
    # @return [String]
    def tree_bank_string
      span, text, type, res = j_instance.getSpan, j_instance.getText, j_instance.getType, ''
      start = span.getStart

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

    # Composes array representation of sentence tree where
    # each hash has following fields:
    #
    #  :type => <[String] node type>,
    #  :parent_type => <[String] type of parent node>,
    #  :token => <[String] current token>,
    #  :children => <Array[Hash] array of child nodes hashes>
    #
    # @return [Array<Hash>]
    def code_tree
      kids = j_instance.getChildren

      kids.each_with_object([]) do |kid, acc|
        data = { :type => kid.getType, :parent_type => self.j_instance.getType, :token => kid.toString }
        subtree = self.class.new(kid).code_tree
        data[:children] = subtree unless subtree.empty?
        acc << data
      end
    end
  end
end
