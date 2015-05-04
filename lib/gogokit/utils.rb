module GogoKit
  # Utility methods for {GogoKit::Client}
  module Utils
    # Perform an HTTP request an map the to a {Representable::JSON}
    def object_from_response(klass,
                             klass_representer,
                             method,
                             url,
                             options = {})
      response = send(method.to_sym, url, options)
      return nil if response[:status] < 200 ||
                    response[:status] > 299 ||
                    response[:body].nil?

      klass.new.extend(klass_representer).from_json(response[:body])
    end
  end
end
