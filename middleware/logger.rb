require 'logger'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    request_line = "\nRequest: #{env["REQUEST_METHOD"]} "
    request_line << env["PATH_INFO"]
    request_line << "/?#{env["QUERY_STRING"]}" unless env["QUERY_STRING"].empty?
    @logger.info request_line
    
    status, headers, body = @app.call(env)

    if headers['Parameters']
      params_line = "\nParameters: #{headers['Parameters']}"
      @logger.info params_line
      headers.delete('Parameters')
    end  

    if headers['Handler']
      handler_line = "\nHandler: #{headers['Handler']}"
      @logger.info handler_line
      headers.delete('Handler')
    end  

    response_line = "\nResponse: #{status} "
    response_line << "[#{headers['Content-Type']}]"
    response_line << " #{headers['Template']}" if headers['Template']      
    @logger.info response_line

    [status, headers, body]
  end
end
