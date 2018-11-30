class TestsController < Simpler::Controller

  def index
    # @time = Time.now
    # render plain: 'Plain text response'
    # render template: 'tests/list'
    # status 201
    # add_header 'test-header', 'Ok'
  end

  def create

  end

  def show
    @id = params[:id]
  end

  def question
    @test_title = params[:test_title]
    @id = params[:id]     
  end

end
