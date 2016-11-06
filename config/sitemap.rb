SitemapGenerator::Sitemap.default_host = "https://www.wahiga.com"

SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
  fog_provider: 'AWS',
  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  fog_directory: ENV['S3_BUCKET'],
  fog_region: ENV['AWS_REGION'])



SitemapGenerator::Sitemap.sitemaps_host = "https://wahiga.s3-sa-east-1.amazonaws.com/"



SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.public_path = 'tmp/'


articles = Article.where("status = ? AND article_type = ?", "Published", "News")

SitemapGenerator::Sitemap.create do
  articles.each do |a|
    final_url = "News/#{a.friendly_url}"
    if a.game != nil
      final_url = "#{a.game.friendly_url}/news/#{a.friendly_url}"
    end
    add final_url, lastmod: a.updated_at, changefreq: "daily", priority: 1.0
  end 
  Document.all.each do |doc|
    add "images/show_image/#{doc.id}/#{doc.file_name}", lastmod: doc.updated_at, changefreq: "daily", priority: 1.0
  end 
  # here is where you add all the pages you'd like to sitemap
  # add posts_path, priority: 1, changefreq:'always'
  # Post.findeach do |post|
  #   add post_path(post.slug), :lastmod => post.updated_at
  # end
end