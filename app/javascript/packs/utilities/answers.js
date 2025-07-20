// update
$(document).on('turbo:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
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
