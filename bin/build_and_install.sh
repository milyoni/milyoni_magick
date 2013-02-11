#!/bin/bash
build_gem () {
  gem build milyoni_magick.gemspec
}

install_gem () {
  gem install $1 --no-rdoc --no-ri
}

install_gem "$(echo `build_gem` | awk '{print $9}')"


