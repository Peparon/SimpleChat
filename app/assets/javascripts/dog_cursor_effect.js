document.addEventListener('turbolinks:load', () => {
  const dogCursor = document.getElementById('dog-cursor'); // イメージカーソルを取得（image全体を囲う要素）
  const dogImage = document.getElementById('dog-image'); // 画像本体の取得
  const dogArea = document.getElementById('dog-area'); // 追尾アニメーションの範囲の取得

  if (!dogCursor || !dogImage || !dogArea) return; // いずれかが見つからない場合は処理を終了

  let idleTimer; // 一定時間マウスが動かない時のタイマー
  let lastX = 0; // 前回マウスX座標
  let targetX = 0; // 追いかける目標のX座標
  let targetY = 0; // 追いかける目標のY座標
  let currentX = 0; // 画像の現在のX座標
  let currentY = 0; // 画像の現在のY座標
  let isInsideArea = false; // マウスがエリア内にいるかどうかのフラグ

  // マウスがエリア内に入った時
  dogArea.addEventListener('mouseenter', () => {
    isInsideArea = true; // 追尾をON
    dogCursor.style.display = 'block'; // 画像を表示
  });

  dogArea.addEventListener('mousemove', (event) => { // mousemoveはマウスが動いた際のイベント
    if (!isInsideArea) return; // エリア外なら無視

    const x = event.clientX; // マウスの現在位置（画面上のX座標
    const y = event.clientY; // マウスの現在位置（画面上のY座標

    if (x > lastX) { // 移動方向によって画像の向きを変更
      dogImage.style.transform = 'scaleX(-1)'; // 右へ移動で画像を反転
    } else if (x < lastX) {
      dogImage.style.transform = 'scaleX(1)'; // 左へ移動で画像を通常の向きへ
    }
    lastX = x; // 現在のX位置を保存

    // 目的地（マウスの位置）を更新
    targetX = x;
    targetY = y;

    dogImage.src = "/assets/yorkie_walk.png"; // 歩いている画像に切り替え
    clearTimeout(idleTimer); // タイマーリセット（連続で動かした際にdog_stayにならないように）
    idleTimer = setTimeout(() => { // setTimeoutは一定時間動きが停止したらdog_stayに切り替え
      dogImage.src = "/assets/yorkie_stay.png";
    }, 800);
  });

  // 画像の位置を徐々に目標に近づけていく関数アニメーション
  function animate() {
    if (isInsideArea) {
      // 目標との差を少しずつ埋めて滑らかに追尾する
      currentX += (targetX - currentX) * 0.05;
      currentY += (targetY - currentY) * 0.05;
      // 画像を新しい位置へ移動
      dogCursor.style.transform = `translate(${currentX}px, ${currentY}px)`;
    }
    requestAnimationFrame(animate); // フレームを繰り返し
  }
  animate(); // アニメーション開始
});
