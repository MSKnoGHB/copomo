import consumer from "./consumer"

document.addEventListener('turbolinks:load',() =>{
  const adminMoniter = document.querySelector('.admin-moniter-container');
  if (!adminMonitor)return;

  consumer.subscriptions.create("AdminChannel", {
    received(data){
      if (data.type === "active_users_list"){
        const target = document.querySelector(`#active-users-list-${data.room_id}`);
        if(target){
          target.innerHTML = data.html;
        }
      }
    }
  });
});
