module OpenNlp
  class Tool
    attr_reader :j_instance

    def initialize(model)
      raise ArgumentError, "model must be an OpenNlp::Model" unless model.is_a?(OpenNlp::Model)
      @j_instance = self.class.java_class.new(model.j_model)
    end

    class << self
      def java_class=(value)
        @java_class = value
      end

      def java_class
        @java_class
      end
    end
  end
end