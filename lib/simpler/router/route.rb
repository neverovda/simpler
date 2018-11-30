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

      private

      def make_path_regexp(path)
        param_names = path.scan(/:\w+/)
        param_names.each { |name|
          path.sub!(name, "(?<#{name.delete(':')}>\\w+)")
        }
        path.gsub!('/',"\\/" )
        Regexp.new path << '$'
      end

    end
  end
end
