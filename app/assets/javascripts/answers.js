$(document).ready(function() {
  $('a.edit_answer_link').click(function() {
    var answer_id = $(this).data('answerId');
    var form = $('#edit_answer_' + answer_id);
    var title = $('#answer_' + answer_id);


    if ($(this).hasClass('cancel')) {
      $(this).html('<p>Edit answer</p>');
      $(this).removeClass('cancel');
    } else {
      $(this).html('<p>Cancel</p>');
      $(this).addClass('cancel');
    }
    form.toggle();
    title.toggle();
  })
})