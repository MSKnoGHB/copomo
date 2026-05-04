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
import 'chartjs-adapter-date-fns'; 
import Chartkick from 'chartkick';
window.Chart = Chart;

import * as bootstrap from 'bootstrap'; 
import { event } from "jquery";

window.bootstrap = bootstrap;

Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener("turbolinks:load", () =>{


  const timer = document.getElementById("timer")
  if (!timer) return  

  console.log("preview属性:", document.documentElement.hasAttribute("data-turbolinks-preview"));
  if (document.documentElement.hasAttribute("data-turbolinks-preview")) return;
  console.log("turbolinks:load発火 → setInterval追加"); 
  console.log("発火 soundPlayed:", window.soundPlayed, "playSound:", sessionStorage.getItem("playSound"));
  const playSound = sessionStorage.getItem("playSound");
  window.soundPlayed = false;
  sessionStorage.removeItem("playSound"); 
  if (playSound) {
    const focusSound = '/audios/focus_sound.mp3';
    const breakSound = '/audios/break_sound.mp3';
    const sound = playSound == "集中" ? focusSound : breakSound;
    const audio = new Audio(sound);
    audio.play().catch((e) => {
      console.log('音声の再生がブロックされました', e);
    });
    console.log("turbolinks:load 発火");
  }
  


  let remaining = parseInt(timer.innerText)
  function updateDisplay(){
    let minutes = Math.floor(remaining / 60)
    let seconds = remaining % 60
    seconds = seconds.toString().padStart(2, '0')
    timer.innerText = minutes + ":" + seconds
  }

  const intervalId = setInterval(() =>{
    remaining -= 1
    updateDisplay()
    if (remaining <= 10) {
      const modalOpen = document.body.classList.contains('modal-open');
      if (modalOpen) {
        remaining = 10;
      } else {
        const roomId = timer.dataset.roomId;
        fetch(`/public/rooms/${roomId}/check_timer`)
          .then(res => res.json())
          .then(data => {
            if (data.remaining <= 0) {
              const currentMode = timer.dataset.mode;
              sessionStorage.setItem("isAutoReload", "true");
              sessionStorage.setItem("playSound", currentMode);
              clearInterval(intervalId);
              window.location.reload();
            } else {
              remaining = data.remaining;
            }
          })
      }
    }
  }, 1000)
});