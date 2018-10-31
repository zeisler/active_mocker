# frozen_string_literal: true

module ActiveMocker
  module AliasAttribute
    # Is +new_name+ an alias?
    def attribute_alias?(new_name)
      attribute_aliases.key? new_name.to_s
    end

    # Returns the original name for the alias +name+
    def attribute_alias(name)
      attribute_aliases[name.to_s]
    end

    private

    def attribute_aliases
      @attribute_aliases ||= {}
    end
  end
end
