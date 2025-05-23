document.addEventListener('turbolinks:load', function () {
  const chatMessages = document.getElementById('chat-messages');
  if (chatMessages) {
    chatMessages.scrollTop = chatMessages.scrollHeight;
  }
});