module RESTAPI
  class << self
    def find_path(hash, field)
      paths = []
      hash.each do |k, v|
        if k == field
          paths << k
        elsif v.kind_of?(Hash)
          if find_path(v, field).size.positive?
            paths += find_path(v, field).map {|p| k << '.' << p}
          end
        end
      end
      paths
    end
  end

  class Component
    attr_reader :api, :name

    def initialize(api, name)
      @api, @name = api, name
    end

    def find_path(field)
      RESTAPI.find_path(self, field)
    end

    def list
      api.get(name) do |res|
        if res.error?
          raise HTTPError
        else
          return res.body, res.status
        end
      end
    end

    def get(id)
      api.get(name, id) do |res|
        if res.error?
          raise HTTPError
        else
          return res.body, res.status
        end
      end
    end

    def post(id, body, params)
      api.post(id, body, params) do |res|
        if res.error?
          raise HTTP::SecurityError
        else
          return res.body, res.status
        end
      end
    end
  end
end