document.addEventListener('DOMContentLoaded', () => {
  const bulbs = document.querySelectorAll('.bulb');

  bulbs.forEach((bulb, index) => {
    bulb.style.animation = `swing 2s ease-in-out infinite`;
    bulb.style.animationDelay = `${index % 2 === 0 ? 0 : 1}s`
  });
});

// アニメーション定義
const style = document.createElement('style');
style.innerHTML = `
@keyframes swing {
  0% { transform: rotate(15deg); }
  50% { transform: rotate(-15deg); }
  100% { transform: rotate(15deg); }
}`;

document.head.appendChild(style);