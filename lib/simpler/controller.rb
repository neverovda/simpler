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
      
      set_default_headers
      send(action)
      write_response
      
      @request.env['simpler.handler'] = "#{self.class.name}##{action}"

      @response.finish
    end

    def params
      @params ||= path_params.merge(request_params)
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

    def path_params
      @request.env['simpler.path_params']
    end

    def request_params
      @request.params
    end

    def render(options)
      if Hash(options)[:plain] 
        @response['Content-Type'] = 'text/plain' 
      end  
      @request.env['simpler.view_options'] = options
    end

    def status(code)
      @response.status = code
    end
    
  end
end
