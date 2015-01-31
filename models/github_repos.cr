require "json"
require "./github_repo"

class GithubRepos
  json_mapping({
    total_count: { type: Int32 },
    items: { type: Array(GithubRepo) }
  })

  def items
    @items.sort_by(&.watchers_count).reverse
  end
end
