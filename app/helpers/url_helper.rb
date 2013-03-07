module UrlHelper
  def with_subdomain(subdomain)
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    [subdomain, request.domain].join
  end

  def url_for(options = {})
    options[:subdomain] ||= false if options.is_a?(Hash)
    if options.kind_of?(Hash) && options.has_key?(:subdomain)
      options[:host] = with_subdomain(options.delete(:subdomain))
    end
    # super(:host => request.host, :port => request.port) # fix error when visit by direct ip
    super({})
  end
end
