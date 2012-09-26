module OpenNlp
  module Utils
    class Span
      include JavaClass

      self.java_class = Java::opennlp.tools.util.Span

      attr_reader :j_instance

      def initialize(start_offset, end_offset)
        @j_instance = self.class.java_class.new(start_offset, end_offset)
      end
    end
  end
end