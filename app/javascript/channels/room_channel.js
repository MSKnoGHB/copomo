import consumer from "./consumer"
let chatSubscription;

document.addEventListener("turbolinks:load", () => {
  const chatCheck = document.getElementById("chat-logs-container");

  if (chatCheck) {
    if (chatSubscription) {
      consumer.subscriptions.remove(chatSubscription);
    }

    const roomId = chatCheck.dataset.roomId;
    
    chatSubscription = consumer.subscriptions.create({ channel: "RoomChannel", room_id: roomId }, {
      received(data) {
        if (data && data.chat_log_html) {
          const chatElement = document.getElementById("chat-logs-container");
          if (chatElement) {
            chatElement.insertAdjacentHTML("beforeend", data.chat_log_html);
            chatElement.scrollTop = chatElement.scrollHeight;
            const inputElement = document.getElementById("chat-input");
            if (inputElement) {
              inputElement.value = '';
            }
          }
        } 
      }
    });
  }
});