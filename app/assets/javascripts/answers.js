$(document).ready(function() {

  $(document).bind('ajax:error', function(e, xhr, status, error) {
    if (status == 403) {
      alert('У вас нет прав');
    }
  })

  var answerBlock = function(id, body) {
    return '<div class="answer" id="answer_'
      + id + '"><p class="answer_body">'
      + body + '</p><form style="display: none" class="edit_answer" id="edit_answer_'
      + id + '" action="/answers/'
      + id + '" accept-charset="UTF-8" data-remote="true" method="post"><input name="utf8" type="hidden" value="&#x2713;" /><input type="hidden" name="_method" value="patch" /><textarea name="answer[body]" id="answer_body"></textarea><input type="submit" name="commit" value="Update" /></form><p><a class="edit_answer_link" data-answer-id="'
      + id + '" href="#">Edit answer</a></p><p><a class: "delete_answer_link" data-confirm="Are you sure?" data-remote="true" rel="nofollow" data-method="delete" href="/answers/'
      + id + '">Delete answer</a></p></div>';
  }

  $('form.new_answer').bind('ajax:success', function(e, answer, status, xhr) {
    $('.answers').append(answerBlock(answer.id, answer.body));
    $('#new_answer_body').val('');
    $('.answer-errors').html('');
  }).bind('ajax:error', function(e, xhr, status, error) {
    errors = jQuery.parseJSON(xhr.responseText);
    jQuery.each(errors, function(index, message) {
      $('.answer-errors').append('<p style="color: red">' + message + '</p>');
    })
  })

  $('a.delete_answer_link').bind('ajax:success', function(e, answer, status, xhr) {
    $('#answer_' + answer.id).remove();
    $('.answer-errors').html('');
  })

  $('form.edit_answer').bind('ajax:success', function(e, answer, status, xhr) {
    $('#answer_' + answer.id).replaceWith(answerBlock(answer.id, answer.body));
    $('.answer-errors').html('');
  }).bind('ajax:error', function(e, xhr, status, error) {
    errors = jQuery.parseJSON(xhr.responseText);
    jQuery.each(errors, function(index, message) {
      $('.answer-errors').append('<p style="color: red">' + message + '</p>');
    })
  })

  $('a.edit_answer_link').click(function() {
    var answer_id = $(this).data('answerId');
    var form = $('#edit_answer_' + answer_id);
    var title = $('#answer_' + answer_id).find('.answer_body');

    if ($(this).hasClass('cancel')) {
      $(this).html('Edit answer');
      $(this).removeClass('cancel');

    } else {
      $('form.edit_answer').hide();
      $('.edit_answer_link.cancel').html('Edit answer');
      $('.answer_body').show();

      $(this).html('Cancel');
      $(this).addClass('cancel');
    }
    form.toggle();
    title.toggle();
  })
})