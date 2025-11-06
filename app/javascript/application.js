// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "channels"
import Rails from "@rails/ujs";
Rails.start();
import "jquery";

import "packs/utilities/gist_render"
import "packs/utilities/answers"
import "packs/utilities/questions"
import "packs/utilities/links"
import "packs/utilities/votes"

import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

import "@nathanvda/cocoon"
