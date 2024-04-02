require 'functions_framework'
require 'logger'
require_relative 'lib/validator'

include Validator
$logger = Logger.new($stdout)

FunctionsFramework.http 'cpf_cnpj_validator' do |request|
    if request.options?
        # Allows POST requests from any origin with the Content-Type
        # header and caches preflight response for an 3600s
        headers = {
            "Access-Control-Allow-Origin"  => "*",
            "Access-Control-Allow-Methods" => "POST",
            "Access-Control-Allow-Headers" => "Content-Type",
            "Access-Control-Max-Age"       => "3600"
        }
        return [204, headers, []]
    end

    return response_message('Invalid Request Headers.') unless request.post?
    
    input = JSON.parse request.body.read rescue {}
    

end

def response_message(message)
    ::Rack::Response.new({ message: message }.to_json)
end
