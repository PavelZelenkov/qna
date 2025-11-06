import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  received(data) {
    if (data.action === 'new_question') {
      this.handleNewQuestion(data)
    }
  },

  handleNewQuestion(data) {
    const questionsList = document.querySelector('ul.questions')
    
    if (questionsList) {
      questionsList.insertAdjacentHTML('afterbegin', data.html)
    }
  }
})

function initQuestionsChannel() {
  const qid = window.gon && window.gon.question_id
  
  if (!qid || !window.JST) return
  
  consumer.subscriptions.create(
    { 
      channel: "QuestionsChannel", 
      question_id: qid 
    },
    {
      received(data) {
        if (data.answer) {
          const ctx = { 
            answer: data.answer, 
            current_user_id: window.gon && window.gon.current_user_id 
          }
          
          const html = window.JST["templates/answers/answer"](ctx)
          const box = document.querySelector(".answers-container")
          
          if (!box) return
          
          const tmp = document.createElement("div")
          tmp.innerHTML = html
          const node = tmp.firstElementChild
          const old = node && node.id ? document.getElementById(node.id) : null
          
          old ? old.replaceWith(node) : box.insertAdjacentHTML("afterbegin", html)
        }
        
        if (data.comment) {
          this.handleNewComment(data)
        }
      },
      
      handleNewComment(data) {
        const commentableType = data.commentable_type.toLowerCase()
        const commentableId = data.commentable_id
        const containerId = `${commentableType}_${commentableId}-comments`
        const commentsContainer = document.querySelector(`ul#${containerId}`)
        
        if (!commentsContainer) {
          console.error(`Comments container not found: ${containerId}`)
          console.log('Available containers:', 
            Array.from(document.querySelectorAll('ul[id$="-comments"]'))
              .map(el => el.id)
          )
          return
        }
        commentsContainer.insertAdjacentHTML('beforeend', data.comment.html)
      }
    }
  )
}

document.addEventListener("turbo:load", initQuestionsChannel)

document.addEventListener("ajax:success", function(e) {
  const form = e.target;
  if (form.matches("form[data-remote][id^='new-comment-']")) {
    form.reset();
    
    const errorsDiv = form.querySelector('.errors');
    if (errorsDiv) {
      errorsDiv.style.display = 'none';
      errorsDiv.innerHTML = '';
    }
  }
});

document.addEventListener("ajax:error", function(e) {
  const form = e.target;
  
  if (form.matches("form[data-remote][id^='new-comment-']")) {
    const [data, status, xhr] = e.detail;
    
    let errorsDiv = form.querySelector('.errors');
    
    if (!errorsDiv) {
      errorsDiv = document.createElement('div');
      errorsDiv.className = 'errors';
      errorsDiv.style.marginTop = '10px';
      
      const actionsDiv = form.querySelector('.actions');
      form.insertBefore(errorsDiv, actionsDiv);
    }
    
    errorsDiv.innerHTML = '';
    
    try {
      const response = JSON.parse(xhr.response);
      const errors = response.errors;
      
      if (errors && errors.length > 0) {
        errors.forEach(function(error) {
          const errorP = document.createElement('p');
          errorP.style.margin = '5px 0';
          errorP.textContent = error;
          errorsDiv.appendChild(errorP);
        });
        
        errorsDiv.style.display = 'block';
      }
    } catch (error) {
      console.error('Error parsing server response:', error);
      errorsDiv.innerHTML = '<p>An error occurred. Please try again.</p>';
      errorsDiv.style.display = 'block';
    }
  }
});
