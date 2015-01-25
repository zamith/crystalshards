require "ecr/macros"

class Views::Index
  getter :crystal_repos

  def initialize(@crystal_repos); end

  ecr_file "./views/index.ecr"
end
