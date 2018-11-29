require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      if options.is_a? Hash
        return options[:plain] + "\n" if options[:plain]
        return render_erb(binding) if options[:template]
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
      @env['simpler.view-options']
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

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

  end
end
