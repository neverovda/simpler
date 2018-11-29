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
      param = @request.env['PATH_PARAM']
      @request.params[param[:name]] =param[:value]

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    def not_found
      set_default_headers
      status 404
      @response.write File.read(Simpler.root.join('public/404.html'))
      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
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

    def params
      @request.params
    end

    def render(options)
      @request.env['simpler.view-options'] = options
    end

    def status code
      @response.status = code
    end

    def extract_param(str_param)
      
    end

  end
end
