require "json"
require "./github_repo"

class GithubRepos
  json_mapping({
    total_count: { type: Int32 },
    items: { type: Array(GithubRepo) }
  })
end
