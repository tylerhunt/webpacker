# Install webpacker
puts "Creating javascript app source directory"
directory "#{__dir__}/javascript", "app/javascript"

puts "Copying binstubs"
template "#{__dir__}/bin/webpack-dev-server", "bin/webpack-dev-server"
template "#{__dir__}/bin/webpack-watcher", "bin/webpack-watcher"
template "#{__dir__}/bin/webpack", "bin/webpack"
if !File.exist?("bin/yarn")
  puts "Copying yarn"
  template "#{__dir__}/bin/yarn", "bin/yarn"
end
chmod "bin", 0755 & ~File.umask, verbose: false

puts "Copying webpack core config and loaders"
directory "#{__dir__}/config/webpack", "config/webpack"
directory "#{__dir__}/config/loaders/core", "config/webpack/loaders"
copy_file "#{__dir__}/config/.postcssrc.yml", ".postcssrc.yml"

if File.exists?(".gitignore")
  append_to_file ".gitignore", <<-EOS
/public/packs
/node_modules
EOS
end

puts "Installing all JavaScript dependencies"
run "./bin/yarn add webpack webpack-merge js-yaml path-complete-extname " \
"webpack-manifest-plugin babel-loader coffee-loader coffee-script " \
"babel-core babel-preset-env compression-webpack-plugin rails-erb-loader glob " \
"extract-text-webpack-plugin node-sass file-loader sass-loader css-loader style-loader " \
"postcss-loader autoprefixer postcss-smart-import precss"

puts "Installing dev server for live reloading"
run "./bin/yarn add --dev webpack-dev-server"

puts "Webpacker successfully installed 🎉 🍰"
