require "frank"
require "http/client"
require "./views/index"
require "./models/github_repos"

def headers
  headers = HTTP::Headers.new
  headers["User-Agent"] = "crystalshards"
  headers
end

def crystal_repos
  client = HTTP::Client.new("api.github.com", 443, true)
  response = client.get("/search/repositories?q=language:crystal&per_page=100", headers)
  GithubRepos.from_json(response.body)
end

get "/" do |context|
  context.response.content_type = "text/html"
  Views::Index.new crystal_repos
end
