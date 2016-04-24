class OpenNlp::Util::Span
  include OpenNlp::JavaClass

  self.java_class = Java::opennlp.tools.util.Span

  attr_reader :j_instance

  # Initializes new instance of Util::Span
  #
  # @param [Integer] s start index of the span
  # @param [Integer] e end index of the span
  def initialize(s, e)
    raise ArgumentError, 's should be an integer' unless s.is_a?(Fixnum)
    raise ArgumentError, 'e should be an integer' unless e.is_a?(Fixnum)

    @j_instance = self.class.java_class.new(s, e)
  end

  # Returns end index of the span
  #
  # @return [Integer]
  def start
    j_instance.getStart
  end

  # Returns end index of the span
  #
  # @return [Integer]
  def end
    j_instance.getEnd
  end

  # Returns type of the span
  #
  # @return [String]
  def type
    j_instance.getType
  end

  # Returns length of the span
  #
  # @return [Integer]
  def length
    j_instance.length
  end

  def ==(other)
    return false unless other.is_a?(self.class)

    [:start, :end, :type].inject(true) do |acc, method|
      acc && public_send(method) == other.public_send(method)
    end
  end
end
