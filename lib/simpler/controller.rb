require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      
      send(action)
      write_response

      @request.env['simpler.parameters'] = params.map { |k,v| [k.to_s, v] }.to_h
      @request.env['simpler.handler'] = "#{self.class.name}##{action}"

      set_headers
      @response.finish
    end

    def self.not_found
      response = Rack::Response.new
      response['Content-Type'] = 'text/html'
      response.status = 404
      response.write File.read(Simpler.root.join('public/404.html'))
      response.finish
    end

    def params
      @params ||= path_params.merge(request_params)
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_headers
      @response['Content-Type'] = @request.env['simpler.content_type']
    end

    def add_header(header, value)
      @response[header] = value
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body      
      View.new(@request.env).render(binding)
    end

    def path_params
      @request.env['simpler.path_params']
    end

    def request_params
      @request.params
    end

    def render(options)
      @request.env['simpler.view_options'] = options
    end

    def status(code)
      @response.status = code
    end
    
  end
end
