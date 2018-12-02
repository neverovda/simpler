module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path_regexp = make_path_regexp(path)
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && match_path(path)
      end

      def match_path(path)
        path.match(@path_regexp)
      end

      def path_params(env)
        path = env['PATH_INFO']
        match_data = self.match_path(path)
        Hash[ match_data.names.map(&:to_sym).zip( match_data.captures ) ]
      end  

      private

      def make_path_regexp(path)
        path_parts = path.split('/')
        path_parts.map! do |part|
          if part[0] == ":"
            part.delete!(':')
            part = "(?<#{part}>\\w+)"
          else
            part  
          end
        end
        str_regexp = path_parts.join("\\/")
        /#{str_regexp}$/
      end

    end
  end
end
