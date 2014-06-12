def hash_to_querystring(hash)
  if hash == nil or hash.empty?
    return ""
  end
  hash.keys.inject('') do |query_string, key|
    query_string << '&' unless key == hash.keys.first
    query_string << "#{URI.encode(key.to_s)}=#{URI.encode(hash[key])}"
  end
end

def http_get(url, p, https=false, port=nil)
  uri = URI.parse(url)
  if port != nil
      _port = port
  elsif https == true
      _port = 443
  else
      _port = uri.port
  end
  http = Net::HTTP.new(uri.host, _port)
  http.use_ssl = true if https
  
  http.get(uri.path+"?"+hash_to_querystring(p), nil)
end 

def http_post(url, p, https=false, port=nil)
    p "==>url=#{url}"
    
  uri = URI.parse(url)
  p "==>uri=#{uri.inspect}"
  
  if port != nil
      _port = port
  elsif https == true
      _port = 443
  else
      _port = uri.port
  end

  http = Net::HTTP.new(uri.host, _port)
  http.use_ssl = true if https
  
  p "-->port:#{_port}, host:#{uri.host}"
	 # Net::HTTP.post_form( url, p)
	 resp, data = http.post(uri.path, hash_to_querystring(p))
	 puts "===>http code #{resp}"
	 return data
end