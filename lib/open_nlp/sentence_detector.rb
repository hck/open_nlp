module OpenNlp
  class SentenceDetector < Tool
    self.java_class = Java::opennlp.tools.sentdetect.SentenceDetectorME

    # Detects sentences in a string
    #
    # @param [String] string string to detect sentences in
    # @return [Array<String>] array of detected sentences
    def detect(str)
      fail ArgumentError, 'str must be a String' unless str.is_a?(String)
      j_instance.sentDetect(str).to_ary
    end

    # Detects sentences in a string and returns array of spans
    #
    # @param [String] str
    # @return [Array<OpenNlp::Util::Span>] array of spans for detected sentences
    def pos_detect(str)
      fail ArgumentError, 'str must be a String' unless str.is_a?(String)
      j_instance.sentPosDetect(str).map do |span|
        OpenNlp::Util::Span.new(span.getStart, span.getEnd)
      end
    end
  end
end
