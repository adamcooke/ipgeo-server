require 'maxminddb'

module IPGeo
  module Database

    def self.database_path
      ENV['MMDB_PATH'] ||= File.expand_path('../../../geoip.mmdb', __FILE__)
    end

    def self.instance
      @database ||= MaxMindDB.new(database_path)
    end

    def self.lookup(ip)
      result = instance.lookup(ip)
      if result.found?
        {
          :ip => ip,
          :country => result.country.iso_code,
          :country_name => result.country.name,
          :city => result.city.name,
          :latitude => result.location.latitude,
          :longitude => result.location.longitude,
          :geoname_id => result.country.geoname_id
        }
      else
        false
      end
    rescue IPAddr::InvalidAddressError, IPAddr::AddressFamilyError => e
      false
    end

  end
end
