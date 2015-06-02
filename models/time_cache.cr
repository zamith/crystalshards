struct TimeCache(K, V)
  def initialize(@expire_time)
    @cache = {} of K => Entry(V)
  end

  def fetch(key : K)
    now = Time.utc_now

    entry = @cache[key]?
    if entry && now < entry.expire_time
      return entry.value
    end

    value = yield key
    @cache[key] = Entry.new(value, now + @expire_time)
    value
  end

  struct Entry(V)
    getter value
    getter expire_time

    def initialize(@value : V, @expire_time)
    end
  end
end
