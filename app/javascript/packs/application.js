// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application"; 

import * as bootstrap from 'bootstrap'; 
window.bootstrap = bootstrap; // ブラウザ全体で bootstrap を使えるようにする

import "../stylesheets/application";


Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener('turbolinks:load', () => {
  const modalElement = document.getElementById('entryModal');
  if (modalElement) {
    // このファイル内では bootstrap が import されているので直接使えます
    // もし jQuery スタイルがお好みなら $('#entryModal').modal('show'); でもOK
    const myModal = new bootstrap.Modal(modalElement, {
      backdrop: 'static',
      keyboard: false
    })
    myModal.show();
  }
});