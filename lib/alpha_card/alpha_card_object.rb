module AlphaCard
  class AlphaCardObject
    include Virtus.model

    def to_query
      Rack::Utils.build_query(self.filled_attributes)
    end

    def filled_attributes
      self.attributes.select { |key, value| value.present? }
    end
  end
end