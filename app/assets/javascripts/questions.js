$(document).ready(function() {

  $('form.edit_question').bind('ajax:success', function(e, question, status, xhr) {
    $('h1.question_title').replaceWith('<h1 class="question_title">' + question.question.title + '</h1>');
    $('p.question_body').replaceWith('<p class="question_body">' + question.question.body + '</p>');
    $('form.edit_question').hide();
    $('a.edit_question_link').removeClass('cancel');
    $('a.edit_question_link').html('Edit question');
    $('.action-errors').html('');
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

  PrivatePub.subscribe('/questions', function(data, channel) {
    question = data['response'].question;
    email = data['response'].email;

    $('.questions').append('<h2><a href="/questions/'
      + question.id + '">'
      + question.title + '</a></h2><div class="author">'
      + email + '</div><p>'
      + '</div><p>'
      + question.body + '</p>');
  })
})