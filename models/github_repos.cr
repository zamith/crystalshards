require "json"
require "./github_repo"

class GithubRepos
  json_mapping({
    items: { type: Array(GithubRepo) }
  })
end
