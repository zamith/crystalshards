require "json"

class GithubRepo
  json_mapping({
    name: { type: String },
    html_url: { type: String },
    description: { type: String, nilable: true },
    watchers_count: { type: Int32 }
    owner: Owner,
    pushed_at: { type: Time, converter: TimeFormat.new("%FT%TZ") },
    forks: { type: Int32 },
  })

  struct Owner
    json_mapping({
      login: String,
    })
  end
end
