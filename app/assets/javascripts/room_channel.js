document.addEventListener("turbolinks:load", () => {
  const chatMessages = document.getElementById("chat-messages");
  if (!chatMessages) return;

  const roomId = chatMessages.dataset.roomId;

  // すでにチャンネルがある場合は解除
  if (App.roomChannel) {
    App.roomChannel.unsubscribe();
  }

  // RoomChannel に接続
  App.roomChannel = App.cable.subscriptions.create(
    { channel: "RoomChannel", room_id: roomId },
    {
      connected() {
        console.log("✅ Connected to RoomChannel");
      },

      disconnected() {
        console.log("❌ Disconnected from RoomChannel");
      },

      received(data) {
        console.log("📨 受信データ:", data);

        const currentUserId = document.body.dataset.currentUserId;
        if (!data.message) return;

        // HTML文字列をDOMに変換
        const tempDiv = document.createElement("div");
        tempDiv.innerHTML = data.message.trim();
        const messageWrapper = tempDiv.querySelector(".message-wrapper");

        if (messageWrapper) {
          const senderId = messageWrapper.dataset.userId;

          // 🚫 自分自身が送信したメッセージなら表示をスキップ
          if (String(senderId) === currentUserId) {
            console.log("⚠️ 自分のメッセージなのでCable表示をスキップ");
            return;
          }

          // ✅ 受信者側として表示
          messageWrapper.classList.add("align-items-start");

          const bubble = messageWrapper.querySelector(".chat-bubble");
          if (bubble) {
            bubble.classList.add("other-message");
          }

          chatMessages.appendChild(messageWrapper);
        } else {
          console.warn("⚠️ message-wrapper が見つかりません");
        }
      },
    }
  );
});