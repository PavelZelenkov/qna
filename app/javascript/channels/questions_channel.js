import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  // connected() {
  //   console.log("Connected to QuestionsChannel")
  //   console.log("All subscriptions:", consumer.subscriptions.subscriptions) // Проверка подключения
  // },

  // disconnected() {
  //   console.log("Disconnected from QuestionsChannel")
  // },

  received(data) {
    console.log('Received data:', data)
    
    if (data.action === 'new_question') {
      this.handleNewQuestion(data)
    }
  },

  handleNewQuestion(data) {
    const questionsList = document.querySelector('ul.questions')
    
    if (questionsList) {
      console.log('Adding new question to list')
      questionsList.insertAdjacentHTML('afterbegin', data.html)
    }
  },
})
