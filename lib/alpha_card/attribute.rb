module AlphaCard
  module Attribute
    # Extends base class with Attributes DSL.
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module ClassMethods
      # Defines Attributes Set for the class.
      # Attributes set contains all the attributes names as key
      # and it's options as the value.
      def attributes_set
        @attributes_set ||= {}
      end

      # Adds attribute to the class.
      # Defines reader and writer methods based on options hash.
      # Adds attribute to the global Attributes Set.
      #
      # @param [Symbol] attribute name
      # @param [Hash] attribute options
      #
      # @example
      #   class User
      #     include AlphaCard::Attribute
      #
      #     attribute :email
      #     attribute :name, default: 'John'
      #     attribute :role, default: 'admin', values: ['admin', 'regular']
      #     attribute :id, writable: false
      #   end
      #
      def attribute(name, options = {})
        define_reader(name)
        define_writer(name, options) if options[:writable].nil? || options[:writable]

        attributes_set[name.to_sym] = options
      end

      # Removes attribute from the class (reader, writer and from Attributes Set).
      #
      # @param [Symbol] attribute name
      #
      # @example
      #   class User
      #     include AlphaCard::Attribute
      #
      #     attribute :email
      #     attribute :name, default: 'John'
      #   end
      #
      #   class Person < User
      #     attribute :email
      #     remove_attribute :name
      #   end
      #
      def remove_attribute(name)
        symbolized_name = name.to_sym

        if attributes_set.keys.include?(symbolized_name)
          undef_method(symbolized_name)
          undef_method("#{name}=") if method_defined?("#{name}=")

          attributes_set.delete(symbolized_name)
        end
      end

      private

      # Writes Attributes Set to the superclass on inheritance.
      def inherited(subclass)
        subclass.instance_variable_set(:@attributes_set, attributes_set.dup)
      end

      # Creates a reader method for the attribute.
      def define_reader(name)
        attr_reader name.to_sym
      end

      # Creates a writer method for the attribute with validation
      # of setting value if options[:values] was passed.
      def define_writer(name, options = {})
        values = options[:values]

        define_method("#{name}=") do |value|
          raise InvalidAttributeValue.new(value, values) if values && !values.include?(value)

          instance_variable_set(:"@#{name}", value)
        end
      end
    end

    module InstanceMethods
      # Constructor supports setting attributes when creating a new instance of the class.
      # Sets default values for the attributes if they are present.
      #
      # @param [Hash] attributes
      #   object attributes
      #
      # @example
      #   class User
      #     include AlphaCard::Attribute
      #
      #     attribute :email
      #     attribute :name, default: 'John'
      #   end
      #
      #   User.new()
      #   #=> #<User:0x29cca00 @email=nil, @name="John">
      #
      def initialize(attributes = {})
        set_attributes_defaults

        attributes.each do |name, value|
          set_attribute_safely(name, value)
        end
      end

      # Returns class instance attributes.
      #
      # @example
      #   class User
      #     include AlphaCard::Attribute
      #
      #     attribute :email
      #     attribute :name, default: 'John'
      #   end
      #
      #   User.new.attributes
      #   #=> { email: nil, name: 'John' }
      #
      def attributes
        self.class.attributes_set.each_with_object({}) do |(name, _), attributes|
          attributes[name] = __send__(name)
        end
      end

      protected

      # Set attribute value only if attribute writable
      def set_attribute_safely(name, value)
        __send__("#{name}=", value) if attribute_writable?(name)
      end

      # Checks if attribute is writable by it's options in the Attributes Set.
      def attribute_writable?(name)
        attribute_options = self.class.attributes_set[name.to_sym]
        return false if attribute_options.nil?

        attribute_options[:writable].nil? || attribute_options[:writable]
      end

      # Sets default values for the attributes, based on Attributes Set.
      def set_attributes_defaults
        self.class.attributes_set.each do |attr_name, options|
          instance_variable_set(:"@#{attr_name}", options[:default])
        end
      end
    end
  end
end
