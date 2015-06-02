require "frank"
require "http/client"
require "./views/index"
require "./models/github_repos"
SORT_OPTIONS = {"stars", "updated", "forks"}

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

def fetch_sort(context)
  sort = context.params["sort"]? || "stars"
  sort = "stars" unless SORT_OPTIONS.includes?(sort)
  sort
end

get "/" do |context|
  sort = fetch_sort(context)
  context.response.content_type = "text/html"
  Views::Index.new crystal_repos(sort), sort
end
