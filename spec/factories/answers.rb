FactoryGirl.define do
  sequence :body do |n|
    "Answer body #{n}"
  end

  factory :answer do
    body
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end

  factory :question_with_answers, class: 'Answer' do
    body
    question
  end
end
