FactoryGirl.define do
  factory :question do
    title "My question"
    body "Question's Body"
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
