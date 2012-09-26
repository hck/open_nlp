module OpenNlp
  class Model
    include JavaClass

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

      @j_model = self.class.java_class.new(model_stream)
    end
  end
end
