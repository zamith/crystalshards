require "json"
require "html"

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

  def name
    HTML.escape @name
  end

  def html_url
    HTML.escape @html_url
  end

  def description
    @description ? HTML.escape @description.not_nil! : nil
  end

  struct Owner
    JSON.mapping({
      login: String,
    })

    def login
      HTML.escape @login
    end
  end
end
