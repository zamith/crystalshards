require "json"
require "./github_repo"

class GithubRepos
  JSON.mapping({
    total_count: { type: Int32 },
    items: { type: Array(GithubRepo) }
  })

  def dup
    GithubRepos.from_json self.to_json
  end
end
