module OpenNlp
  class Model
    attr_reader :j_model

    def initialize(model)
      model_stream = case model
                     when java.io.FileInputStream
                       model
                     when String
                       java.io.FileInputStream.new(model)
                     else
                       raise ArgumentError, "Model must be either a string or a java.io.FileInputStream"
                     end

      @j_model = self.class.java_class_name.new(model_stream)
    end

    class << self
      def java_class_name=(value)
        @java_class = value
      end

      def java_class_name
        @java_class
      end
    end
  end
end
