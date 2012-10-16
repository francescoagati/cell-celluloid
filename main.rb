require 'action_pack'
require 'cell/base'
require "cell/rails/helper_api"
require 'celluloid'


#define a cell that render an action get_time
class Render < ::Cell::Base

  include Cell::Rails::HelperAPI

  def get_time
    @time=Time.new.to_s
    render
  end

end

#assign path for templates
Render.append_view_path("./views")

# an actor that implements the message get_time
class Actor
  
  attr_accessor :render
  include Celluloid
  
  def initialize
    @render=Render.new
  end

  def get_time
    render.render_state(:get_time)
  end
end

#create a pool of 50 actors
pool = Actor.pool(size:50)

#we do 100 rendering of cell Render sending 100 message to Actor and get the results of future
list_time=(0..100).to_a.map { |n| pool.future(:get_time) }.map {|actor| actor.value }
p list_time
