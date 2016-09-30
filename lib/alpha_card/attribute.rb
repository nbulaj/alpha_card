module Attribute
  InvalidValue = Class.new(StandardError)

  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
    def attributes_set
      @attributes_set ||= {}
    end

    def attribute(name, options = {})
      define_reader(name)
      define_writer(name, options) if options[:writer].nil? || options[:writer]

      attributes_set[name.to_sym] = options
    end

    private

    def define_reader(name)
      attr_reader name.to_sym
    end

    def define_writer(name, options = {})
      values = options[:values]

      define_method("#{name}=") do |value|
        raise InvalidValue if values && !values.include?(value)

        instance_variable_set(:"@#{name}", value)
      end
    end
  end

  module InstanceMethods
    def initialize
      set_attributes_defaults
    end

    def set_attributes_defaults
      self.class.attributes_set.each do |attr_name, options|
        default = options[:default].nil? ? nil : options[:default].clone
        instance_variable_set(:"@#{attr_name}", default)
      end
    end
  end
end
