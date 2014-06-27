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
      # Default separators for query string.
      DEFAULT_SEP = /[&;] */n

      # A part of the rack gem.
      class KeySpaceConstrainedParams
        def initialize(limit = 65536)
          @limit = limit
          @size = 0
          @params = {}
        end

        def [](key)
          @params[key]
        end

        def []=(key, value)
          @size += key.size if key && !@params.key?(key)
          raise RangeError, 'exceeded available parameter key space' if @size > @limit
          @params[key] = value
        end

        def key?(key)
          @params.key?(key)
        end

        def to_params_hash
          hash = @params
          hash.keys.each do |key|
            value = hash[key]
            if value.kind_of?(self.class)
              hash[key] = value.to_params_hash
            elsif value.kind_of?(Array)
              value.map! { |x| x.kind_of?(self.class) ? x.to_params_hash : x }
            end
          end
          hash
        end
      end

      ##
      # Unescapes a URI escaped string with +encoding+. +encoding+ will be the
      # target encoding of the string returned, and it defaults to UTF-8
      if defined?(::Encoding)
        def unescape(s, encoding = Encoding::UTF_8)
          URI.decode_www_form_component(s, encoding)
        end
      else
        def unescape(s, encoding = nil)
          URI.decode_www_form_component(s, encoding)
        end
      end

      ##
      # Parses a query string to a Hash by breaking it up
      # at the '&' and ';' characters.
      def parse_query(qs, d = nil, &unescaper)
        unescaper ||= method(:unescape)

        params = KeySpaceConstrainedParams.new

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

        params.to_params_hash
      end
    end
  end
end