import consumer from "./consumer"

document.addEventListener('turbolinks:load',() =>{
  const adminMonitor = document.getElementById('admin-monitor-container')
  if (!adminMonitor)return;

  const roomId = adminMonitor.dataset.roomId;

  consumer.subscriptions.create({channel: "AdminChannel", room_id: roomId}, {
    received(data){
      if (data.type === "active_users_list"){
        adminMonitor.innerHTML = data.active_users_list_html;
      }
    }
  });
});
