require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer, question: question) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe "POST #create" do
    before { login(user) }

    context 'valid' do
      it 'saves new answer links with question in DB' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer), format: :json
        }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
      end
    end

    context 'invalid' do
      it 'does not save new answer in DB' do
        expect {
          post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :json
        }.to_not change(Answer, :count)
      end

      it 'render create template' do
      end
    end
  end

  describe "GET #edit" do
    before do
      login(user)
      get :edit, id: answer
    end

    it 'edits answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit template' do
      expect(response).to render_template :edit
    end
  end

  describe "PATCH #update" do
    before { login(user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'valid' do
      before { patch :update, id: answer, answer: { body: 'New Body' } }
      it 'changes answer' do
        answer.reload
        expect(answer.body).to eq 'New Body'
      end

      it 'render show template' do
      end
    end

    context 'invalid' do
      before { patch :update, id: answer, answer: { body: nil } }
      it 'does not change question attributes' do
        answer.reload
        expect(answer.body).to_not eq nil
      end

      it 'renders edit template' do
      end
    end

    context "non-author can't edit answer" do
      it 'does not edit answer in DB' do
        patch :update, id: answer, answer: { body: 'New Body' }
        expect(answer.body).to_not eq 'New Body'
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      login(user)
    end

    context "author delete his own answer" do
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'deletes answer from DB' do
        expect { delete :destroy, id: answer, format: :json }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
      end
    end

    context "non-author can't delete answer" do
      before { answer }

      it 'does not delete answer from DB' do
        expect { delete :destroy, id: answer, format: :json }.to_not change(Answer, :count)
      end
    end
  end
end
