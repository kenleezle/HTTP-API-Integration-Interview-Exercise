require 'rubygems'
require 'json'
require 'net/http'

class ImmunizationStatus
  attr_reader :status
  attr_reader :severity

  def initialize(status,severity)
    @status = status
    @severity = severity
  end

  def to_s
    "status: #{status}\nseverity: #{severity}"
  end

  STATUSES = ["out-of-date","current"]
  SEVERITIES = ["low", "medium", "high", "none"]

  @@base_url = 'http://imm.caredox.com'
  @@resource = 'immunization_status'
  @@port = 80

  def self.base_url=(url)
    @@base_url = url
  end
  def self.resource=(resource)
    @@resource = resource
  end
  def self.port=(port)
    @@port = port
  end
  def self.url
    "#{@@base_url}:#{@@port}/#{@@resource}"
  end
  def self.find_by_person_id_and_state(id,state)
    # With a logging infrastructure i'd log the following comment
    # [ERROR] ImmunizationStatus only accepts 2 character states! #{state} is invalid.
    # Alternatively depending on the context we could raise exceptions
    return nil unless state =~ /[A-Za-z][A-Za-z]/

    # [ERROR] ImmunizationStatus only accepts integer person ids! #{id} is invalid.
    return nil unless id.is_a? Integer

    uri = URI.parse("#{url}?person-id=#{id}&state=#{state}")

    req = Net::HTTP::Get.new(uri.path)

    begin
      res = Net::HTTP.start(uri.host, uri.port) { |http|
        http.request(req)
      }
    rescue => e
       # "[ERROR] Did not receive response from #{url}: #{e}"
      return nil
    end

    unless res.is_a?(Net::HTTPSuccess)
      # "[ERROR] #{url} is not returning HTTP 200 OK"
      return nil
    end

    response = JSON.parse(res.body)

    # [ERROR] Received bad status from #{url} for person id and state #{id} #{state}
    return nil unless STATUSES.include?(response['status'])

    # [ERROR] Received bad severity from #{url} for person id and state #{id} #{state}
    return nil unless SEVERITIES.include?(response['severity'])

    return ImmunizationStatus.new(response['status'],response['severity'])
  end
end
