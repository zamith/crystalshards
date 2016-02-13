require "kemal"
require "http/client"
require "emoji"
require "./views/index"
require "./models/github_repos"
require "./models/time_cache"

SORT_OPTIONS = {"stars", "updated", "forks"}
REPOS_CACHE = TimeCache(String, GithubRepos).new(30.minutes)

def headers
  headers = HTTP::Headers.new
  headers["User-Agent"] = "crystalshards"
  headers
end

def crystal_repos
  client = HTTP::Client.new("api.github.com", 443, true)
  response = client.get("/search/repositories?q=language:crystal&per_page=100", headers)
  total_repos = GithubRepos.from_json(response.body).total_count
  repos = GithubRepos.from_json(response.body)

  max_pages = (total_repos.to_f / 100).round.to_i
  max_pages.times do |i|
    page = i + 1
    next if page == 1

    client = HTTP::Client.new("api.github.com", 443, true)
    response = client.get("/search/repositories?q=language:crystal&per_page=100&page=#{page}", headers)
    current_page_repos = GithubRepos.from_json(response.body)
    current_page_repos.items.each do |item|
      repos.items << item
    end
  end

  repos
end

def filter(repos, filter)
  filtered = repos.dup
  filtered.items.select! { |item| matches_filter?(item, filter) }
  filtered.total_count = filtered.items.size
  filtered
end

def sort(repos, sort)
  sorted = repos.dup
  case sort
  when "stars"
    sorted.items.sort! { |a, b| b.stargazers_count <=> a.stargazers_count  }
  when "updated"
    sorted.items.sort! { |a, b| b.updated_at <=> a.updated_at  }
  when "forks"
    sorted.items.sort! { |a, b| b.forks_count <=> a.forks_count  }
  end
  sorted
end

def fetch_sort(context)
  sort = context.params["sort"]?.try(&.to_s) || "stars"
  sort = "stars" unless SORT_OPTIONS.includes?(sort)
  sort
end

def fetch_filter(env)
  env.params["filter"]?.try(&.to_s.strip.downcase) || ""
end

private def matches_filter?(item : GithubRepo, filter : String)
  item.name.downcase.includes?(filter) ||
    item.description.try(&.downcase.includes? filter)
end

get "/" do |env|
  sort = fetch_sort(env)
  filter = fetch_filter(env)
  env.response.content_type = "text/html"
  repos = REPOS_CACHE.fetch("repos") { crystal_repos }
  repos = filter(repos, filter) unless filter.empty?
  repos = sort(repos, sort)
  Views::Index.new repos, sort, filter
end
