require "json"

class GithubRepo
  JSON.mapping({
    name: { type: String },
    html_url: { type: String },
    description: { type: String, nilable: true },
    watchers_count: { type: Int32 },
    owner: Owner,
    pushed_at: { type: Time, converter: Time::Format.new("%FT%TZ") },
    forks: { type: Int32 },
  })

  struct Owner
    JSON.mapping({
      login: String,
    })
  end
end
