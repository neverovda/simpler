require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      plain = Hash(options)[:plain]
      if plain
        "#{plain}\n"
      else
        render_erb(binding)
      end
    end

    def render_erb(binding)
      template = File.read(template_path)

      ERB.new(template).result(binding)
    end

    private

    def options
      @env['simpler.view_options']
    end

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      options[:template] if options.is_a? Hash
    end

    def template_path
      path = template || [controller.name, action].join('/')
      
      template_name = "#{path}.html.erb"
      @env['simpler.template'] = template_name
      
      Simpler.root.join(VIEW_BASE_PATH, template_name)
    end

  end
end
