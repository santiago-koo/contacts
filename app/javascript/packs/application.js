// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import "bootstrap"
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

const images = require.context('../../assets/images', true)
const imagePath = (name) => images(name, true)

var jQuery = require("jquery")

global.$ = global.jQuery = jQuery
window.$ = window.jQuery = jQuery
