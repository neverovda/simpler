module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :param_name

      def initialize(method, path, controller, action)
        @method = method
        @path_regexp = make_path_regexp(path)
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && path.match(@path_regexp)
      end

      private

      def make_path_regexp(path)
        path_point = path.split(':')
        str = path_point[0]
        if path_point[1]
          str << '\d+'
          @param_name = path_point[1]
        end  
        str << '$'
        Regexp.new str
      end

    end
  end
end
