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

  // リターン条件　タイマー表示有無
  const timer = document.getElementById("timer")
  if (timer) {
    console.log("RoomPageのため処理を実行します");
  } else { 
    console.log("RoomPageではないため処理を中断します");
    return;
  };
 
  // リターン条件　モーダル表示有無
  const entryModal = document.getElementById('entryModal');
  const showModal = timer.dataset.showModal === 'true';
  if (showModal){
    const myModal = new bootstrap.Modal(entryModal, {
      backdrop: 'static',
      keyboard: false
    });
    myModal.show();
    console.log(`モーダルを表示のためreturnします`);
    return;
  };
  console.log(`モーダルを非表示のため処理を実行します`);
  //変数定義 ページ読み込み時のサーバーの残り秒数を取得
  let remaining = parseInt(timer.innerText)

  //関数　分:秒形式に変換しタイマーに表示
  function updateDisplay(){
    let minutes = Math.floor(remaining / 60)
    let seconds = remaining % 60
    seconds = seconds.toString().padStart(2, '0')
    timer.innerText = minutes + ":" + seconds
  }

  //関数　モード切り替え時にタイマー音を鳴らす
  function playTimerSound(mode){
    const focusSound = '/audios/focus_sound.mp3';
    const breakSound = '/audios/break_sound.mp3';
    const sound = mode == "集中" ? focusSound : breakSound;
    new Audio(sound).play();
  }

  //関数　インターバルリロード処理
  function intervalReloadProcess(){
    const currentModeSave = timer.dataset.mode;
    sessionStorage.setItem("playSound", currentModeSave);
    sessionStorage.setItem("skipAutoPaused", "true");
    clearInterval(intervalId);
    console.log(`リロードします`);
    window.location.reload();
  }

  //auto_paused実行判断
  function sendAutoPaused() {
    const skipJudgement = sessionStorage.getItem("skipAutoPaused")
    console.log(`skipJudgement = ${skipJudgement}`);
    if(skipJudgement){
      console.log(`sendAutoPausedをスキップしました`);
      resetProcess()
      return;
    } else {
      navigator.sendBeacon("/public/study_intervals/auto_paused");
      console.log(`sendAutoPausedを実行しました`);
      resetProcess()
    };
  }

  // リセット処理
  function resetProcess(){
    clearInterval(intervalId);
    sessionStorage.removeItem("skipAutoPaused"); 
    window.removeEventListener("beforeunload", sendAutoPaused);
    document.removeEventListener("turbolinks:before-visit", sendAutoPaused);
    console.log(`4件のリセット処理を実行しました`);
  }

  //関数呼び出し　タイマー音
  const savedMode = sessionStorage.getItem("playSound");
  if (savedMode){
    playTimerSound(savedMode);
    sessionStorage.removeItem("playSound"); 
  }

  //フロント側タイマーカウントダウン
  const intervalId = setInterval(() =>{
    if (remaining > 0){
      remaining -= 1
      updateDisplay()
    } else {
      //サーバー側のタイマーチェック
      const roomId = timer.dataset.roomId;
      fetch(`/public/rooms/${roomId}/check_timer`)
        .then(res => res.json())
        .then(server_data => {
          //関数呼出し　インターバルリロード処理
          console.log(`サーバーからタイマー情報を取得しました`);
          if (server_data.remaining <= 0) {
            intervalReloadProcess();
            
          } else {
            remaining = server_data.remaining;
            console.log(`サーバー内タイマーを同期しました`)
            intervalReloadProcess();
          }
        })
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

  //学習終了ボタンを押したときに"skipAutoPaused"のフラグを立てる

  Rails.confirm = (message, element) => {
    console.log('Rails.confirm が呼ばれました');
    console.log('element:', element);
    console.log('element.dataset:', element.dataset);
    const result = window.confirm(message);
    console.log('result:', result);
    if (result && element.dataset.skipAutoPaused === "true") {
      sessionStorage.setItem("skipAutoPaused", "true");
      console.log(`skipAutoPaused="true" をセットしました`);
    }
    return result;
  };
  
  window.addEventListener("beforeunload", sendAutoPaused);
  document.addEventListener("turbolinks:before-visit", sendAutoPaused);

});