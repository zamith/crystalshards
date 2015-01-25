require "json"

class GithubRepo
  json_mapping({
    name: { type: String },
    html_url: { type: String },
    description: { type: String, nilable: true }
  })
end
