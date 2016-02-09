require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe "POST #create" do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer), format: :json
        }.to change(question.answers, :count).by(1)
      end

      it 'renders JSON' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :json
        expect(response.body).to be_json_eql(question.answers[0].to_json).at_path("answer")
      end

      it 'publishes to PrivatePub' do
        expect(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}/answers", kind_of(Hash))
        post :create, question_id: question, answer: attributes_for(:answer)
      end
    end

    context 'invalid' do
      it 'does not save new answer in DB' do
        expect {
          post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :json
        }.to_not change(Answer, :count)
      end

      it 'returns 422 status if error appears' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :json
        expect(response.status).to eq 422
      end
    end
  end

  describe "GET #edit" do
    let(:answer) { create(:answer, question: question) }
    before do
      login(user)
      get :edit, id: answer
    end

    it 'edits answer' do
      expect(assigns(:answer)).to eq answer
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

      it 'renders JSON' do
        answer.reload
        expect(response.body).to be_json_eql(question.answers[0].to_json).at_path("answer")
      end
    end

    context 'invalid' do
      before { patch :update, id: answer, answer: { body: nil } }
      it 'does not change question attributes' do
        answer.reload
        expect(answer.body).to_not eq nil
      end

      it 'returns 422 status if error appears' do
        answer.reload
        expect(response.status).to eq 422
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
    before { login(user) }

    context "author delete his own answer" do
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'deletes answer from DB' do
        expect { delete :destroy, id: answer, format: :json }.to change(Answer, :count).by(-1)
      end

      it 'renders JSON' do
        delete :destroy, id: answer, format: :json
        expect(response.body).to be_json_eql(answer.body.to_json).at_path('answer/body')
      end
    end

    context "non-author can't delete answer" do
      let!(:answer) { create(:answer, question: question) }

      it 'does not delete answer from DB' do
        expect { delete :destroy, id: answer, format: :json }.to_not change(Answer, :count)
      end
    end
  end

  describe "#make_best" do
    let!(:answer) { create(:answer, question: question) }

    before do
      login(user)
      question.best_answer = answer
      question.save
    end
    
    it 'author of question can choose best answer' do
      question.reload
      expect(question.best_answer_id).to eq answer.id
    end
  end
end
