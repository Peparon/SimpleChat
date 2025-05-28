document.addEventListener("turbolinks:load", () => {
  // メッセージ一覧を表示する要素（div）を取得
  const chatMessages = document.getElementById("chat-messages");
  if (!chatMessages) return; // 要素がなければ処置を中断
  // html上に埋め込んだroomIdを取得
  const roomId = chatMessages.dataset.roomId;

  // すでにチャンネルがある場合は解除
  if (App.roomChannel) {
    App.roomChannel.unsubscribe(); // 接続解除
  }

  // 新しくRoomChannelに接続
  App.roomChannel = App.cable.subscriptions.create(
    { channel: "RoomChannel", room_id: roomId }, // 接続先のチャンネル情報
    {
      // 接続された際に実行
      connected() {
        console.log("Connected to RoomChannel"); // 接続確認用ログ
      },
      // 接続が切れた際に実行
      disconnected() {
        console.log("Disconnected from RoomChannel"); // 切断確認用ログ
      },
      // メッセージを受け取った際に呼ばれる処理
      received(data) {
        console.log("受信データ:", data); // サーバーから受け取ったデータの中身を表示
        // 自身のuserIdをhtmlから取得
        const currentUserId = document.body.dataset.currentUserId;
        if (!data.message) return; // メッセージがからなら何もしない

        // HTML文字列をDOM要素に変換
        const tempDiv = document.createElement("div");
        tempDiv.innerHTML = data.message.trim();
        // .messageWrapper（メッセージ1つ分のラッパー）を取得
        const messageWrapper = tempDiv.querySelector(".message-wrapper");
        // メッセージが正しく取得できていれば表示処理へ進む
        if (messageWrapper) {
          const senderId = messageWrapper.dataset.userId;
          // 自分自身が送信したメッセージなら表示をスキップ
          if (String(senderId) === currentUserId) {
            console.log("自分のメッセージなのでCable表示をスキップ");
            return;
          }
          // 受信メッセージとして表示
          messageWrapper.classList.add("align-items-start");
          // 吹き出し部分に他人用のスタイルを追加
          const bubble = messageWrapper.querySelector(".chat-bubble");
          if (bubble) {
            bubble.classList.add("other-message");
          }
          // チャット画面にメッセージを追加
          chatMessages.appendChild(messageWrapper);
        } else {
          // 期待する要素が取得できなかった場合の警告
          console.warn("message-wrapper が見つかりません");
        }
      },
    }
  );
});