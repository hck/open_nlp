module OpenNlp
  class Model
    include JavaClass

    attr_reader :j_model

    def initialize(model)
      model_stream = case model
                     when Java::JavaIO::FileInputStream
                       model
                     when String
                       Java::JavaIO::FileInputStream.new(model)
                     else
                       raise ArgumentError, "Model must be either a string or a Java::JavaIO::FileInputStream"
                     end

      @j_model = self.class.java_class.new(model_stream)
    end
  end
end
