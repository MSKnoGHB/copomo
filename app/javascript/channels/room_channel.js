import consumer from "./consumer"
//二重接続の防ぐ
let chatSubscription;

document.addEventListener("turbolinks:load", () => {
  //チャット入力欄のIDが存在するか確認
  const inputElement = document.getElementById("chat-input");
  //チャット入力欄のIDが存在するか確認
  if(inputElement){
    inputElement.addEventListener("keydown",(e)=>{
      //Enterが押された且つShiftは押されていない条件
      if(e.key === "Enter"&& !e.shiftKey){
        //本来の動作の改行を禁止する
        e.preventDefault();
        //送信フォームを特定
        const form = inputElement.closest("form");
        if(form){
          //送信する
          form.requestSubmit();
        }
      }
    });
  }
  
  //チャット表示欄のIDが存在するか確認
  const chatCheck = document.getElementById("chat-logs-container");
  //チャット表示欄のIDが存在している且つ古い接続（chatSubscription）が残っていれば削除
  if (chatCheck) {
    if (chatSubscription) {
      consumer.subscriptions.remove(chatSubscription);
    }
    //HTMLからルームIDを受け取る
    const roomId = chatCheck.dataset.roomId;
    //サーバ側へチャンネルの接続確立を依頼
    chatSubscription = consumer.subscriptions.create({ channel: "RoomChannel", room_id: roomId }, {
      //データの受取
      received(data) {
        if (data && data.chat_log_html) {
          const chatElement = document.getElementById("chat-logs-container");
          if (chatElement) {
            //吹き出しを画面に追加する
            chatElement.insertAdjacentHTML("beforeend", data.chat_log_html);
            //一番下までスクロールする
            chatElement.scrollTop = chatElement.scrollHeight;
            if (inputElement) {
              //入力欄をクリアする
              inputElement.value = '';
            }
          }
        } 
      }
    });
  }
});