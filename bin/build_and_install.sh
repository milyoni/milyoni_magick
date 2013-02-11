#!/bin/bash
build_gem () {
  gem build milyoni_magick.gemspec
}

install_gem () {
  gem install $1 --no-rdoc --no-ri
}

GEM_FILE="$(echo `build_gem` | awk '{print $9}')"
install_gem $GEM_FILE
rm $GEM_FILE


