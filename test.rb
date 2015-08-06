require 'Typhoeus'

page = "http://www.cnn.com/search/?text=Obama"
request = Typhoeus::Request.get(page, :headers=>{"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.125 Safari/537.36"})

puts request.response_body
