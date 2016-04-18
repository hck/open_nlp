module OpenNlp
  class Model
    include JavaClass

    attr_reader :j_model

    # Initializes new instance of Model
    #
    # @param [String, java.io.FileInputStream] model
    def initialize(model)
      @j_model = self.class.java_class.new(model_stream(model))
    end

    private

    def model_stream(model)
      case model
      when java.io.FileInputStream
        model
      when String
        java.io.FileInputStream.new(model)
      else
        fail ArgumentError, 'Model must be either a string or a java.io.FileInputStream'
      end
    end
  end
end
