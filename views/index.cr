require "ecr/macros"

class Views::Index
  getter :crystal_repos, :repos_count

  def initialize(repos_data)
    @repos_count = repos_data.total_count
    @crystal_repos = repos_data.items
  end

  ecr_file "./views/index.ecr"
end
