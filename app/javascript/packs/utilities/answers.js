// update
$(document).on('turbo:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })

  function clearAnswerErrors() {
    $('.answer-errors').empty();
  }
  function clearAnswerForm() {
    var $form = $('form.new-answer');
    if ($form.length) {
      $form[0].reset();

      var fileInput = $form.find('input[type="file"]');
      var newFileInput = fileInput.clone();
      newFileInput.prop('disabled', false);
      newFileInput.val('');
      fileInput.replaceWith(newFileInput);

      $form.find('input[type="hidden"][name^="answer[files]"]').remove();

      if (window.ActiveStorage && window.ActiveStorage.start) {
        window.ActiveStorage.start();
      }
    }
  }

  $('form.new-answer').on('ajax:success', function(e) {
    var answer = e.detail[0];
    $('.answers').append(answer.html);

    clearAnswerErrors();
    clearAnswerForm()
  })
    .on('ajax:error', function(e) {
      var errors = e.detail[0];

      clearAnswerErrors();

      $.each(errors, function(index, value) {
        $('.answer-errors').append('<p>' + value + '</p>')
      })
    })
});

// delete
$(document).on('turbo:load', function(){
  $('.answers').on('click', '.delete-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $("#answer-" + answerId).remove();
    alert('Your answer has been successfully deleted');
  })
});

// best answer
$(document).on('turbo:load', function(){
  $('.answers').on('click', '.mark-as-best', function(e) {
    e.preventDefault();
    var answer = $(this).closest('.answer');
    $(this).text('best answer');
    answer.prependTo('.answers-container');
    $('.answer:eq(1) .mark-as-best').html("choose the best answer")
  })
});
