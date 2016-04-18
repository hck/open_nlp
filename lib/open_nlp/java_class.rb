module OpenNlp
  module JavaClass
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_accessor :java_class
    end
  end
end
