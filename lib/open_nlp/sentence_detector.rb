module OpenNlp
  class SentenceDetector < Tool
    self.java_class = Java::opennlp.tools.sentdetect.SentenceDetectorME

    def detect(string)
      raise ArgumentError, "string must be a String" unless string.is_a?(String)
      @j_instance.sentDetect(string).to_ary
    end
  end
end