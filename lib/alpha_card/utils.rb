module AlphaCard
  ##
  # Some stolen methods to clear library dependencies.
  class Utils
    ##
    # This one is from the rack gem. It is useful for
    # parsing of Alpha Card Gateway response body.
    # @see https://github.com/rack/rack rack gem GitHub
    class << self
      ##
      # Default separators for the query string.
      DEFAULT_SEP = /[&;] */n

      ##
      # Unescapes a URI escaped string with +encoding+. +encoding+ will be the
      # target encoding of the string returned, and it defaults to UTF-8
      #
      # @param [String] s
      #   String to unescape.
      #
      # @param [Encoding] encoding
      #   Type of <code>Encoding</code>.
      #
      # @return [String] URI encoded string
      #
      # @raise [ArgumentError] if invalid Encoding is passed
      #
      # @example
      #
      #   unescape('Test%20str')
      #   #=> "Test str"
      #
      #   unescape('Test%20str', Encoding::WINDOWS_31J)
      #   #=> "Test str"
      def unescape(s, encoding = Encoding::UTF_8)
        URI.decode_www_form_component(s, encoding)
      end

      ##
      # Parse query string to a <code>Hash</code> by breaking it up
      # at the '&' and ';' characters.
      #
      # @param [String] qs
      #   query string
      # @param [String] d
      #   delimiter for the params
      # @yieldparam unescaper
      #   method, that will unescape the param value
      #
      # @return [Hash] query
      #
      # @example
      #
      #   query = AlphaCard::Utils.parse_query("param1=value1&params2=")
      #   #=> {"param1"=>"value1", "params2"=>""}
      #
      #   query = AlphaCard::Utils.parse_query("cars[]=Saab&cars[]=Audi")
      #   #=> {"cars[]"=>["Saab", "Audi"]}
      def parse_query(qs, d = nil, &unescaper)
        unescaper ||= method(:unescape)

        params = {}

        (qs || '').split(d ? /[#{d}] */n : DEFAULT_SEP).each do |p|
          next if p.empty?
          k, v = p.split('=', 2).map(&unescaper)

          if cur = params[k]
            if cur.class == Array
              params[k] << v
            else
              params[k] = [cur, v]
            end
          else
            params[k] = v
          end
        end

        params
      end
    end
  end
end