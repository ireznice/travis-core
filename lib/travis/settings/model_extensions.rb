module Travis
  class Settings
    module AccessorExtensions
      def set(instance, value)
        if instance.frozen?
          raise 'setting values is not supported on default settings'
        end

        super
      end

      def get(instance)
        if type.primitive <= Travis::Settings::Model
          unless instance.instance_variable_get(instance_variable_name)
            value = Travis::Settings::Model.new
            if instance.frozen?
              return value
            else
              set(instance, value)
            end
          end
        elsif type.primitive <= Travis::Settings::EncryptedValue
          unless instance.instance_variable_get(instance_variable_name)
            value = Travis::Settings::EncryptedValue.new(nil)
            if instance.frozen?
              return value
            else
              set(instance, value)
            end
          end
        end

        super instance
      end
    end

    module ModelExtensions
      module ClassMethods
        def attribute(name, type = nil, options = {})
          options[:finalize] = false

          super name, type, options

          attribute = attribute_set[name]
          attribute.extend(AccessorExtensions)
          attribute.finalize
          attribute.define_accessor_methods(attribute_set)

          self
        end

        def load(json)
          instance = new()

          json = JSON.parse(json) if json.is_a?(String)
          instance.load json if json
          instance
        end
      end

      def self.included(base)
        base.extend ClassMethods
      end

      def attribute?(key)
        attributes.keys.include? key.to_sym
      end

      def to_hash
        attributes.each_with_object({}) do |(name, value), hash|
          hash[name] = value.respond_to?(:to_hash) ? value.to_hash : value
        end
      end

      def collection?(name)
        # TODO: I don't like this type of class checking, it will be better to work
        # based on an API contract, but it should do for now
        if attribute = attribute_set[name.to_sym]
          attribute.type.primitive <= Travis::Settings::Collection
        end
      end

      def encrypted?(name)
        if attribute = attribute_set[name.to_sym]
          attribute.type.primitive <= Travis::Settings::EncryptedValue
        end
      end

      def model?(name)
        if attribute = attribute_set[name.to_sym]
          attribute.type.primitive <= Travis::Settings::Model
        end
      end

      def get(key)
        if attribute?(key)
          self.send(key)
        end
      end
      private :get

      def set(key, value)
        if attribute?(key)
          self.send("#{key}=", value)
        end
      end
      private :set

      def load(hash)
        hash.each do |key, value|
          if collection?(key) || encrypted?(key) || model?(key)
            get(key).load(value)
          elsif attribute?(key)
            set(key, value)
          end
        end
      end
    end
  end
end
