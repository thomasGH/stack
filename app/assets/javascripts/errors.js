$(document).ready(function() {
  $(document).bind('ajax:error', function(e, xhr, status, error) {
    errors = jQuery.parseJSON(xhr.responseText);
    $('.action-errors').html('');
    jQuery.each(errors, function(index, message) {
      $('.action-errors').append('<p style="color: red">' + message + '</p>');
    })
    if (status == 403) {
      alert('У вас нет прав на выполнение этого действия');
    }
  })
})