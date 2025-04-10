$(document).on('turbo:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })
});

$(document).on('turbo:load', function(){
  $('.answers').on('click', '.delete-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $("#answer-" + answerId).remove();
    alert('Your answer has been successfully deleted');
  })
});
