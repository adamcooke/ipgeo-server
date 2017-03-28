require 'json'
require 'ip_geo/database'
require 'rack-custom-proxies'

module IPGeo
  class Server

    def call(env)
      request = Rack::Request.new(env)
      case env['PATH_INFO']
      when "/"
        json(200, {'usage' => {'method' => 'GET', 'path' => '/{IP}', :expect => 'application/json'}})
      when /\A\/[a-f0-9\:\.]+\z/
        if !valid_ip?(request.ip)
          json(403, {'status' => 'UnauthorizedNetwork', :ip => request.ip})
        elsif result = IPGeo::Database.lookup(env['PATH_INFO'].gsub(/\A\//, ''))
          json(200, result)
        else
          json(404, 'status' => 'NotFound')
        end
      else
        json(400, 'status' => 'InvalidPath')
      end
    end

    private

    def json(status, json)
      json = json.to_json
      [status, {'Content-Type' => 'application/json', 'Content-Length' => json.bytesize.to_s}, [json]]
    end

    def valid_ip?(ip)
      if networks.empty?
        true
      else
        ip_addr = IPAddr.new(ip)
        networks.each do |net|
          return true if net.include?(ip_addr)
        end
        return false
      end
    end

    def networks
      @networks ||= begin
        ENV['AUTHORIZED_NETS'] ? ENV['AUTHORIZED_NETS'].split(',').map { |i| IPAddr.new(i) } : []
      end
    end

  end
end
