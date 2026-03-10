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

import Chart from 'chart.js/auto';
import 'chartjs-adapter-date-fns'; // ← これを追加！(importするだけでOK)
import Chartkick from 'chartkick';
window.Chart = Chart;

import * as bootstrap from 'bootstrap'; 
window.bootstrap = bootstrap; // ブラウザ全体で bootstrap を使えるようにする

Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener("turbolinks:load", () =>{
  const timer = document.getElementById("timer")
  if (!timer) return

  let remaining = parseInt(timer.innerText)
  function updateDisplay(){
    let minutes = Math.floor(remaining / 60)
    let seconds = remaining % 60
    seconds = seconds.toString().padStart(2, '0')
    timer.innerText = minutes + ":" + seconds
  }

  updateDisplay()

  setInterval(() =>{
    remaining -= 1
    updateDisplay()
    if (remaining <= 0){
      const modalOpen = document.body.classList.contains('modal-open');
      if (modalOpen) {
        remaining = 10;
      } else {
        location.reload();
      }
    }
  }, 1000)

  const stampBtn = document.getElementById("stamp-btn")
  const stampModal = document.getElementById("stamp_modal")

  if (stampBtn && stampModal){
    stampBtn.addEventListener("click", () => {
      stampModal.classList.toggle("d-none")
      stampModal.classList.toggle("d-flex")
    })
    document.querySelectorAll(".stamp-item").forEach(item => {
      item.addEventListener("click",()=>{
        document.getElementById("stamp-id").value = item.dataset.id
        stampModal.classList.add("d-none")
        stampModal.classList.remove("d-flex")
        document.getElementById("chat-form").requestSubmit()
        document.getElementById("stamp-id").value = ""
      })
    })
  }
})