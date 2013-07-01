require "sinatra"
require 'builder'
require 'twitter'
require 'rinku'

class GiveMeTheDamnRSS < Sinatra::Base
  before do
    Twitter.configure do |config|
      config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
      config.oauth_token = ENV["TWITTER_OAUTH_TOKEN"]
      config.oauth_token_secret = ENV["TWITTER_OAUTH_SECRET"]
    end
  end

  get '/' do
    redirect "http://github.com/chrismetcalf/givemethedamnrss"
  end

  get '/search.rss' do
    results = Twitter.search(params[:q], result_type: "recent", count: params[:count] || 100)

    @title = "Twitter search results for \"#{params[:q]}\""
    @description = "Total search results: #{results.statuses.count}"
    @link = "https://twitter.com/search?q=#{params[:q]}"
    @posts = results.statuses.collect do |tweet|
      {
        :title => Rinku.auto_link("#{tweet.from_user}: #{tweet.full_text}"),
        :body => Rinku.auto_link("
          Author: #{tweet.from_user}<br/>
          Text: #{tweet.full_text}<br/>
          URLs: #{(tweet.urls || []).collect { |u| u.expanded_url }.join(", ")}
        "),
        :created_at => tweet.created_at,
        :guid => "https://twitter.com/#{tweet.from_user}/status/#{tweet.id}",
        :link => (tweet.urls.nil? || tweet.urls.count <= 0) ? "https://twitter.com/#{tweet.from_user}/status/#{tweet.id}" : tweet.urls.first.expanded_url
      }
    end

    builder :rss
  end

  get '/home_timeline.rss' do
    results = Twitter.home_timeline(count: params[:count] || 500)

    @title = "Homepage tweets for #{Twitter.user.screen_name}"
    @description = "Total updates: #{results.count}"
    @link = "https://twitter.com"
    @posts = results.collect do |tweet|
      {
        :title => Rinku.auto_link("#{tweet.from_user}: #{tweet.full_text}"),
        :body => Rinku.auto_link("
          Author: #{tweet.from_user}<br/>
          Text: #{tweet.full_text}<br/>
          URLs: #{(tweet.urls || []).collect { |u| u.expanded_url }.join(", ")}
        "),
        :created_at => tweet.created_at,
        :guid => "https://twitter.com/#{tweet.from_user}/status/#{tweet.id}",
        :link => (tweet.urls.nil? || tweet.urls.count <= 0) ? "https://twitter.com/#{tweet.from_user}/status/#{tweet.id}" : tweet.urls.first.expanded_url
      }
    end

    builder :rss
  end
  
  get '/mentions_timeline.rss' do
    results = Twitter.mentions_timeline(count: params[:count] || 500)

    @title = "Mentions of #{Twitter.user.screen_name}"
    @description = "Total updates: #{results.count}"
    @link = "https://twitter.com"
    @posts = results.collect do |tweet|
      {
        :title => Rinku.auto_link("#{tweet.from_user}: #{tweet.full_text}"),
        :body => Rinku.auto_link("
          Author: #{tweet.from_user}<br/>
          Text: #{tweet.full_text}<br/>
          URLs: #{(tweet.urls || []).collect { |u| u.expanded_url }.join(", ")}
        "),
        :created_at => tweet.created_at,
        :guid => "https://twitter.com/#{tweet.from_user}/status/#{tweet.id}",
        :link => (tweet.urls.nil? || tweet.urls.count <= 0) ? "https://twitter.com/#{tweet.from_user}/status/#{tweet.id}" : tweet.urls.first.expanded_url
      }
    end

    builder :rss
  end
end
