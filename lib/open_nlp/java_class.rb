module OpenNlp
  module JavaClass
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def java_class=(value)
        @java_class = value
      end

      def java_class
        @java_class
      end
    end
  end
end