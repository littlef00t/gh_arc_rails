require 'open-uri'
require 'zlib'
require 'yajl'

class LeadersController < ApplicationController
  include EventsHelper

  def index
  end

  def create
    after_date = params[:after_date]
    before_date = params[:before_date]
    count = params[:count].to_i
    if after_date > before_date
      flash.now[:error] = "Please make sure 'After Date' is before the 'Before Date'"
    else
      start_time = get_beginning_of_hour(params[:after_date])
      end_time = get_beginning_of_hour(params[:before_date])
      @repositories = get_repo_event_count(start_time, end_time, count)
    end
    render :index
    # testing = []
    # gz = open('http://data.githubarchive.org/2014-01-01-15.json.gz')
    # js = Zlib::GzipReader.new(gz).read
    # Yajl::Parser.parse(js) do |event|
    #   if event['type'] == 'CommitCommentEvent'
    #     testing << event
    #   end
    # end
    # render json: testing[0]
  end
end
