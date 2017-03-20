module EventsHelper

  def get_url(time)
    'http://data.githubarchive.org/' + time.strftime("%Y-%m-%d-%-k") + '.json.gz'
  end

  def get_beginning_of_hour(time)
    DateTime.parse(time).beginning_of_hour
  end

  def hit_gh_api(time, repos)
    gh_archive_url = get_url(time)
    gz = open(gh_archive_url)
    js = Zlib::GzipReader.new(gz).read
    Yajl::Parser.parse(js) do |event|
      if event['type'] == params[:event]
        if event['repo']
          repo_name = event['repo']['name']
        else
          repo_name = event['repository']['owner'] + "/" + event['repository']['name']
        end
        repos[repo_name] += 1
      end
    end
  end

  def get_repo_event_count(start_time, end_time, count)
    repos = Hash.new { |h, k| h[k] = 0 }

    if start_time == end_time
      repo_count = hit_gh_api(start_time, repos)
    end

    until start_time == end_time
      hit_gh_api(start_time, repos)
      start_time += 60.minutes
    end

    reverse_sort(repos)[0...count]
  end

  def reverse_sort(repos)
    repos.sort_by { |k, v| v }.reverse
  end

end
