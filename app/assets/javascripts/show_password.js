document.addEventListener('turbolinks:load', () => {
  // パスワードの表示/非表示を切り替える機能を設定する共通関数
  // toggleId：アイコン（fa-eye）につけたID
  // fieldId：対象パスワード入力欄用のID
  function setupToggle(toggleId, fieldId) {
    const toggle = document.getElementById(toggleId); // アイコン要素の取得
    const field = document.getElementById(fieldId); // 入力欄の要素を取得

    // 両要素が取得できた時のみ、イベント設定
    if (toggle && field) {
      // アイコンがクリックされた時の処理
      toggle.addEventListener("click", () => {
        // 現在の入力欄のtype(text or password)を調べて、切り替える
        const type = field.getAttribute("type") === "password" ? "text" : "password";
        field.setAttribute("type", type);
        // アイコンをパスワード欄の状態によって表示を変更
        toggle.innerHTML = type === "password" ? '<i class="fas fa-eye"></i>' : '<i class="fas fa-eye-slash"></i>'
      });
    }
  }
  // アカウント編集用
  setupToggle("toggle-password", "password-field")
  setupToggle("toggle-password-confirmation", "password-confirmation-field")
  setupToggle("toggle-current-password", "current-password-field")
  // 新規登録用
  setupToggle("toggle-signup-password", "signup-password")
  setupToggle("toggle-signup-password-confirmation", "signup-password-confirmation")
  // ログイン用
  setupToggle("toggle-signin-password", "signin-password")
});