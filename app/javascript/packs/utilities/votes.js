$(document).on('click', '.vote-btn', function (e) {
  e.preventDefault();
  var votableId   = $(this).data('id');
  var votableType = $(this).data('votable-type') 
  var value       = $(this).data('value');
  if (!votableId || !votableType) return;

  $.ajax({
    url: '/' + votableType + 's/' + votableId + '/vote',
    method: 'POST',
    dataType: 'json',
    data: { value: value },
    headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
    success: function (response) {
      $('#rating_' + votableType + '_' + votableId).text(response.rating);
    },
    error: function (xhr) {
      var msg = (xhr.responseJSON && xhr.responseJSON.errors) ? xhr.responseJSON.errors.join("\n") : 'Request failed';
      alert(msg);
    }
  });
});
