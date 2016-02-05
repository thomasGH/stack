$(document).ready(function() {

  var answerBlock = function(id, body, email, attachment) {
    var block = '<div class="answer" id="answer_'
      + id + '"><p class="answer_body" style="display: block">'
      + body + '</p><p class="author">'
      + email + '</p><form style="display: none" class="edit_answer" id="edit_answer_'
      + id + '" action="/answers/'
      + id + '" accept-charset="UTF-8" data-remote="true" method="post"><input name="utf8" type="hidden" value="&#x2713;" /><input type="hidden" name="_method" value="patch" /><textarea name="answer[body]" id="answer_body">'
      + body + '</textarea><input type="submit" name="commit" value="Update" /></form><p><a class="edit_answer_link" data-answer-id="'
      + id + '" href="#">Edit answer</a></p><p><a class="delete_answer_link" data-confirm="Are you sure?" data-remote="true" rel="nofollow" data-method="delete" href="/answers/'
      + id + '">Delete answer</a></p><p><a class="best_answer_link" data-remote="true" href="/answers/'
      + id + '/best">Best answer</a></p>';

      if (attachment.length > 0) {
        block += '<div class="attachment">Attachments:<ul><li><a href="'
        + attachment[0].file.url + '">'
        + attachment[1] + '</a><a class="delete_answer_attachment_link" data-confirm="Are you sure?" data-remote="true" rel="nofollow" data-method="delete" href="/attachments/'
        + attachment[0].id + '"> (Delete attachment)</a></li></ul></div>';
      }

      block += '<hr /></div>'

      return block;
  }

  $('form.new_answer').bind('ajax:success', function(e, answer, status, xhr) {
    $('.answers').append(answerBlock(answer.answer.id, answer.answer.body, answer.email, answer.attachment));
    $('#new_answer_body').val('');
    $('.action-errors').html('');
  })

  $(document).on('ajax:success', 'a.delete_answer_link', function(e, answer, status, xhr) {
    $('#answer_' + answer.answer.id).remove();
    $('.action-errors').html('');
  })

  $(document).on('ajax:success', 'a.delete_answer_attachment_link', function(e, answer, status, xhr) {
    $('#answer_' + answer.answer.id).replaceWith(answerBlock(answer.answer.id, answer.answer.body, answer.email, answer.attachment));
    $('.action-errors').html('');
  })

  $(document).on('ajax:success', 'form.edit_answer', function(e, answer, status, xhr) {
    $('#answer_' + answer.answer.id).replaceWith(answerBlock(answer.answer.id, answer.answer.body, answer.email, answer.attachment));
    $('.action-errors').html('');
  })

  $(document).on('click', 'a.edit_answer_link', function() {
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

  var bestId = $('.question').data('bestAnswerId');
  $('#answer_' + bestId).prependTo($('.answers'));

  $(document).on('ajax:success', 'a.best_answer_link', function(e, answer, status, xhr) {
    $('#answer_' + answer.answer.id).prependTo($('.answers'));
  })

  questionId = $('.question').data('questionId');
  channel = '/questions/' + questionId + '/answers';

  PrivatePub.subscribe(channel, function(data, channel) {
    answer = data['response'];
   if (answer.answer.user_id != $('body').data('userId')) {
      $('.answers').append(answerBlock(answer.answer.id, answer.answer.body, answer.email, answer.attachment));
   }
  })
})