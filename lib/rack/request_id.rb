require 'securerandom'

module Rack
  class RequestId
    X_REQUEST_ID = "X-Request-Id".freeze

    def initialize(app, opts = {})
      @app = app
    end

    def call(env)
      env['HTTP_X_REQUEST_ID'] = make_request_id(env['HTTP_X_REQUEST_ID'])
      status, headers, body = @app.call(env)
      headers[X_REQUEST_ID] ||= env['HTTP_X_REQUEST_ID']
      [status, headers, body]
    end

    private
    def make_request_id(request_id)
      if !request_id.nil?
        request_id.gsub(/[^\w\-]/, "".freeze).first(255)
      else
        internal_request_id
      end
    end

    def internal_request_id
      SecureRandom.hex(16)
    end
  end
end