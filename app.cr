require "frank"
require "http/client"
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

def crystal_repos(sort)
  client = HTTP::Client.new("api.github.com", 443, true)
  response = client.get("/search/repositories?q=language:crystal&per_page=100&sort=#{sort}", headers)
  GithubRepos.from_json(response.body)
end

def filter(repos, filter)
  filtered = repos.dup
  filtered.items.select! { |item| matches_filter?(item, filter) }
  filtered.total_count = filtered.items.size
  filtered
end

def fetch_sort(context)
  sort = context.params["sort"]? || "stars"
  sort = "stars" unless SORT_OPTIONS.includes?(sort)
  sort
end

def fetch_filter(context)
  context.params["filter"]?.try(&.strip.downcase) || ""
end

private def matches_filter?(item: GithubRepo, filter: String)
  item.name.downcase.includes?(filter) ||
    item.description.try(&.downcase.includes? filter)
end

get "/" do |context|
  sort = fetch_sort(context)
  filter = fetch_filter(context)
  context.response.content_type = "text/html"
  repos = REPOS_CACHE.fetch(sort) { crystal_repos(sort) }
  repos = filter(repos, filter) unless filter.empty?
  Views::Index.new repos, sort, filter
end
