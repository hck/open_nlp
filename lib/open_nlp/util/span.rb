class OpenNlp::Util::Span
  include OpenNlp::JavaClass

  self.java_class = Java::opennlp.tools.util.Span

  attr_reader :j_instance

  # Initializes new instance of Util::Span
  #
  # @param [Integer] start start index of the span
  # @param [Integer] end end index of the span
  def initialize(start_pos, end_pos)
    raise ArgumentError, 'start should be an integer' unless start_pos.is_a?(Integer)
    raise ArgumentError, 'end should be an integer' unless end_pos.is_a?(Integer)

    @j_instance = self.class.java_class.new(start_pos, end_pos)
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

    %i[start end type].inject(true) do |acc, method|
      acc && public_send(method) == other.public_send(method)
    end
  end
end
