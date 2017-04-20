require 'RMagick'
include Magick

cat = ImageList.new("/Users/admin/flatiron/labs/rails/mark-and-scott-rails-project-web-031317/public/uploads/tmp/1492460374-13042-0004-9446/First_day_selfie.jpg")
#cat.display
smallcat = cat.minify
smallcat.edge(radius=0.0).display
