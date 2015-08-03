require "ecr/macros"

class Views::Index
  getter :crystal_repos, :repos_count, :sort, :filter

  def initialize(repos_data, sort, filter = nil)
    @repos_count = repos_data.total_count
    @crystal_repos = repos_data.items
    @sort = sort
    @filter = filter
    @now = Time.utc_now
  end

  def human_time(time)
    diff = (@now - time)
    if diff < 5.minutes
      "just now"
    elsif diff < 1.hour
      "#{diff.total_minutes.to_i} minutes ago"
    elsif diff < 2.hours
      "1 hour ago"
    elsif diff < 1.day
      "#{diff.total_hours.to_i} hours ago"
    elsif diff < 2.days
      "1 day ago"
    else
      "#{diff.total_days.to_i} days ago"
    end
  end

  ecr_file "./views/index.ecr"
end
