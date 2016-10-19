SitemapGenerator::Sitemap.default_host = "https://www.wahiga.com"

SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
  fogprovider: 'AWS',
  awsaccesskeyid: ENV['AWS_ACCESS_KEY_ID'],
  awssecretaccesskey: ENV['AWS_SECRET_ACCESS_KEY'],
  fogdirectory: ENV['S3_BUCKET'],
  fogregion: ENV['AWS_REGION'])



SitemapGenerator::Sitemap.sitemaps_host = "https://s3-#{ENV['AWS_REGION']}.amazonaws.com/#{ENV['S3_BUCKET']}/"



SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.public_path = 'tmp/'


articles = Article.where("status = ? AND article_type = ?", "Published", "News")

SitemapGenerator::Sitemap.create do
  articles.each do |a|
    add "News/#{a.friendly_url}", lastmod: a.updated_at, changefreq: "daily", priority: 1.0
  end 
  # here is where you add all the pages you'd like to sitemap
  # add posts_path, priority: 1, changefreq:'always'
  # Post.findeach do |post|
  #   add post_path(post.slug), :lastmod => post.updated_at
  # end
end