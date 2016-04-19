class OpenNlp::Util::Span
  include OpenNlp::JavaClass

  self.java_class = Java::opennlp.tools.util.Span

  attr_reader :j_instance

  def initialize(s, e)
    fail ArgumentError, 's should be an integer' unless s.is_a?(Fixnum)
    fail ArgumentError, 'e should be an integer' unless e.is_a?(Fixnum)

    @j_instance = self.class.java_class.new(s, e)
  end

  def start
    j_instance.getStart
  end

  def end
    j_instance.getEnd
  end

  def type
    j_instance.getType
  end

  def length
    j_instance.length
  end

  def ==(obj)
    return false unless obj.is_a?(self.class)

    [:start, :end, :type].inject(true) do |acc, method|
      acc && self.public_send(method) == obj.public_send(method)
    end
  end
end
