import consumer from "./consumer"

document.addEventListener("turbolinks:load",()=>{
  const chatElement = document.getElementById('chat-logs-container');

  if(chatElement){
    const roomId = chatElement.dataset.roomId;
    consumer.subscriptions.create({ channel: "RoomChannel", room_id: roomId }, {
      received(data) {
        const html = `<p>${data.user_name}: ${data.message}</p>`;
        chatElement.insertAdjacentHTML('beforeend', html);
      }
    });
  }
});