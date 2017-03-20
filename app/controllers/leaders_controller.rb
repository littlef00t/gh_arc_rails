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
  end
end
