require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe "GET #new" do
    before do
      login(user)
      get :new, question_id: question
    end

    it 'assigns new Answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new template' do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    before { login(user) }

    context 'valid' do
      it 'saves new answer links with question in DB' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer)
        }.to change(question.answers, :count).by(1)
      end

      it 'redirect to show' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'invalid' do
      it 'does not save new answer in DB' do
        expect {
          post :create, question_id: question, answer: attributes_for(:invalid_answer)
        }.to_not change(Answer, :count)
      end

      it 'renders show template' do
        post :create, question_id: question, answer: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end
end
