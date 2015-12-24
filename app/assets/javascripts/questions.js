$(document).ready(function() {

  var questionBlock = function(id, title, body) {
    return '<h1 class="question_title">'
      + title + '</h1><p class="question_body">'
      + body + '</p><form style="display: none" class="edit_question" id="edit_question_'
      + id + '" action="/questions/'
      + id + '" accept-charset="UTF-8" data-remote="true" method="post"><input name="utf8" type="hidden" value="&#x2713;" /><input type="hidden" name="_method" value="patch" /><input type="text" value="'
      + title + '" name="question[title]" id="question_title" /><textarea name="question[body]" id="question_body">'
      + body + '</textarea><input type="submit" name="commit" value="Update" /></form><p><a class="edit_question_link" href="#">Edit question</a></p>';
  }

  $('form.edit_question').bind('ajax:success', function(e, question, status, xhr) {
    $('div.question').replaceWith(questionBlock(question.id, question.title, question.body));
    $('.question-errors').html('');
  }).bind('ajax:error', function(e, xhr, status, error) {
    errors = jQuery.parseJSON(xhr.responseText);
    jQuery.each(errors, function(index, message) {
      $('.question-errors').append('<p style="color: red">' + message + '</p>');
    })
  })

  $('a.edit_question_link').click(function() {

    var form = $('form.edit_question');
    var title = $('.question_title');
    var body = $('.question_body');

    if ($(this).hasClass('cancel')) {
      $(this).html('Edit question');
      $(this).removeClass('cancel');

    } else {
      $(this).html('Cancel');
      $(this).addClass('cancel');
    }
    form.toggle();
    title.toggle();
    body.toggle();
  })
})