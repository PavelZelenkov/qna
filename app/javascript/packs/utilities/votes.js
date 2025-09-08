$(document).on('click', '.vote-btn', function(e) {
  e.preventDefault();
  var votableId = $(this).data('id');
  var votableType = $(this).data('type');
  var value = $(this).data('value');

  $.ajax({
    url: '/' + votableType + 's/' + votableId + '/vote',
    method: 'POST',
    dataType: 'json',
    data: { value: value },
    headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
    success: function(response) {
      $('#rating_' + votableType + '_' + votableId).text(response.rating);
    },
    error: function(xhr) {
      alert(xhr.responseJSON.errors.join("\n"));
    }
  })
})
