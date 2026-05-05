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
  console.log("timer:", timer) 
  if (!timer) return
  console.log("リターンを回避しました(!timer)");

  // リターン条件　モーダル有無
  const entryModal = document.getElementById('entryModal');
  const showModal = timer.dataset.showModal === 'true';

  if (entryModal && showModal) {
    // モーダルあり・表示条件あり → モーダル表示してから処理
    const myModal = new bootstrap.Modal(entryModal, {
      backdrop: 'static',
      keyboard: false
    });
    myModal.show();
    entryModal.addEventListener('hidden.bs.modal', initAll, { once: true });
  } else {
    // モーダルなし or 表示不要 → 直接処理
    initAll();
  }

  function initAll() {
    // ページ読み込み時のサーバーの残り秒数を取得
    let remaining = parseInt(timer.innerText)

    //オートポーズスキップフラグをリセットする
    sessionStorage.removeItem("skipAutoPaused"); 
    console.log(`skipAutoPausedをリセットしました${sessionStorage.getItem("skipAutoPaused")}`);

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
      console.log(`${mode}でサウンドを再生します`);
      new Audio(sound).play();
      console.log(`${sound}の音声を再生しました`);
    }

    //関数　リロード処理
    function reloadProcess(){
      const currentModeSave = timer.dataset.mode;
      sessionStorage.setItem("skipAutoPaused", "true");
      console.log(`skipAutoPausedをセットしました${sessionStorage.getItem("skipAutoPaused")}`);
      sessionStorage.setItem("playSound", currentModeSave);
      console.log(`アイテム(playSound)に保存しました(${currentModeSave})`);
      clearInterval(intervalId);
      console.log(`チェックが完了しました リロードします`);
      //window.skipAutoPaused = false;
      window.location.reload();
    }

    //auto_paused実行判断
    function sendAutoPaused() {
      const skipJudgement = sessionStorage.getItem("skipAutoPaused")
      console.log(`skipAutoPausedをセットしました${skipJudgement}`);
      if(skipJudgement){
        console.log(`sendAutoPausedをスキップしました`);
        return;
      } else {
        navigator.sendBeacon("/public/study_intervals/auto_paused");
        console.log(`sendAutoPausedを実行しました`);
      };
    }

    //関数呼び出し　タイマー音
    const savedMode = sessionStorage.getItem("playSound");
    console.log(`${savedMode}を取得しました`);
    if (savedMode){
      playTimerSound(savedMode);
      sessionStorage.removeItem("playSound"); 
      console.log(`アイテム(playSound)をリムーブしました(${savedMode})`);
    }

    //1秒毎にカウントダウンタイマーを更新
    const intervalId = setInterval(() =>{
      if (remaining > 0){
        remaining -= 1
        updateDisplay()
      } else {
        //サーバーのタイマーチェック
        const roomId = timer.dataset.roomId;
        fetch(`/public/rooms/${roomId}/check_timer`)
          .then(res => res.json())
          .then(server_data => {
            //リロード処理
            console.log(`サーバーからタイマーを取得、チェックを開始します`);
            if (server_data.remaining <= 0) {
              reloadProcess();
            } else {
              remaining = server_data.remaining;
              console.log(`サーバー内タイマーを同期しました`)
              reloadProcess();
            }
          })
      }
    }, 1000)
    

    //学習終了ボタンを押したときに"skipAutoPaused"のフラグを立てる
    document.addEventListener("pointerdown", (event) => {
      const skip_btn = event.target.closest('[data-skip-auto-paused="true"]');
      if (skip_btn) {
        sessionStorage.setItem("skipAutoPaused", "true");
        console.log(`skipAutoPaused="true" をセットしました`);
      }
    });


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

    window.addEventListener("beforeunload", sendAutoPaused);
    document.addEventListener("turbolinks:before-visit", sendAutoPaused);
  }
});