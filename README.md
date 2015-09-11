# Crystalshards

A shard is what we call a crystal libraries, and this is the website that lists
them all.

# Deploying to Heroku

To experiment with this, you can post this to your own heroku site.

You can read about [Deploying to Heroku] or just follow these steps:

```bash
NAME=crystal-shards-demo
heroku create $NAME --buildpack https://github.com/zamith/heroku-buildpack-crystal
git push heroku master
```

[Deploying to Heroku]: https://subvisual.co/blog/posts/63-deploying-a-crystal-application-to-heroku
