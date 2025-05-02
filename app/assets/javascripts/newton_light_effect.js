// document.addEventListener('DOMContentLoaded', () => { // DOMContentLoadedではリロードなしではアニメーションを実行できなかった
document.addEventListener('turbolinks:load', () => { // turbolinks:loadにすることでリロードなしで発火可能！
  // 左右の振り子の電球指定！ parentElement（取得のためのプロパティ）で親要素のswing-setを取得！
  const leftSwing = document.querySelector('.swing-set .bulb[data-swing="left"]').parentElement;
  const rightSwing = document.querySelector('.swing-set .bulb[data-swing="right"]').parentElement;
  // svgの曲線の取得するための要素
  const leftStringPath = leftSwing.querySelector('.string-svg path');
  const rightStringPath = rightSwing.querySelector('.string-svg path');
  // 左右のstringカーブを変形させる。offsetXが＋なら右、ーなら左。Cはベジェ曲線（曲がった線）指定。
  const updateStringPath = (path, offsetX) => {
    const d = `M1 0 C ${1 + offsetX * 0.6} 50, ${1 + offsetX * 0.6} 90, 1 140`;
    path.setAttribute('d', d);
  };
  // 振り子を指定した方向に揺らす
  const startSwing = (swing, animationName, duration, path, direction) => {
    if (swing) {
      swing.style.animation = 'none'; // アニメーションを一旦リセット
      void swing.offsetWidth; // リセットを強制的に再読み込み
      swing.style.animation = `${animationName} ${duration} cubic-bezier(0.4, 0, 1, 1) forwards`;
      animateString(path, direction, parseFloat(duration) * 1000);  // stringを揺らす処理を同時呼び出し
    }
  };
  // 振り子を中央に戻して停止。同時にoffsetX = 0で停止。
  const stopSwing = (swing, path) => {
    if (swing) {
      swing.style.animation  = 'none';
      swing.style.transform = 'rotate(0deg)';
    }
    if (path) {
      updateStringPath(path, 0);
    }
  };

  const animateString = (path, direction, duration = 1000) => {
    const startTime = performance.now(); // アニメーション開始時間
    const maxOffset = direction === 'left' ? 20 : -20;

    const loop = (now) => {
      const elapsed = now - startTime;
      if (elapsed >= duration) {
        updateStringPath(path, 0);
        return;
      }

      const angle = Math.sin((elapsed / duration) * Math.PI); // 揺れの角度
      const offsetX = maxOffset * angle; // 最大の曲がりに応じた位置

      updateStringPath(path, offsetX);
      requestAnimationFrame(loop); // 次フレームで繰り返し
    };

    requestAnimationFrame(loop);
  };
  // 左右交互に動きを繰り返す
  const loopSwings = () => {
    startSwing(leftSwing, 'swing-left', '1s', leftStringPath, 'left');
    setTimeout(() => {
      stopSwing(leftSwing);
      startSwing(rightSwing, 'swing-right', '1s', rightStringPath, 'right');
    }, 1000);

    setTimeout(() => {
      stopSwing(rightSwing);
      loopSwings(); // 繰り返し
    }, 2000);
  };

  loopSwings();
});

// アニメーション定義
const style = document.createElement('style');
style.innerHTML = `
@keyframes swing-left {
  0% { transform: rotate(0deg); animation-timing-function: cubic-bezier(0.4, 0, 1, 1); }
  50% { transform: rotate(60deg); animation-timing-function: cubic-bezier(0.4, 0, 1, 1); }
  100% { transform: rotate(0deg); }
}
@keyframes swing-right {
  0% { transform: rotate(0deg); animation-timing-function: cubic-bezier(0.4, 0, 1, 1); }
  50% { transform: rotate(-60deg); animation-timing-function: cubic-bezier(0.4, 0, 1, 1); }
  100% { transform: rotate(0deg); }
}
`;

document.head.appendChild(style);