require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe "GET #index" do
    before { get :index }

    it 'loads all questions' do
      questions = create_list(:question, 3)
      expect(assigns(:questions)).to eq questions
    end

    it 'renders index template' do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    before { get :show, id: question }

    it 'loads question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show template' do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    before do
      login(user)
      get :new
    end

    it 'assigns new Question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new template' do
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    before do
      login(user)
      get :edit, id: question
    end

    it 'edits question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit template' do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    before { login(user) }

    context 'valid' do
      it 'saves new question in DB' do
        expect {
          post :create, question: attributes_for(:question)
        }.to change(Question, :count).by(1)
      end

      it 'redirect to show' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to questions_path
      end
    end

    context 'invalid' do
      it 'does not save new question in DB' do
        expect {
          post :create, question: attributes_for(:invalid_question)
        }.to_not change(Question, :count)
      end

      it 'renders show template' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    before { login(user) }
    let!(:question) { create(:question, user: user) }

    context 'valid' do
      before { patch :update, id: question, question: { title: 'New Title', body: 'New Body' } }
      it 'changes question' do
        question.reload
        expect(question.title).to eq 'New Title'
        expect(question.body).to eq 'New Body'
      end

      it 'render show template' do
      end
    end

    context 'invalid' do
      before { patch :update, id: question, question: { title: nil, body: nil } }
      it 'does not change question attributes' do
        question.reload
        expect(question.title).to_not eq nil
        expect(question.body).to_not eq nil
      end

      it 'renders edit template' do
      end
    end

    context "non-author can't edit question" do
      it 'does not edit question in DB' do
        patch :update, id: question, question: { title: 'New Title', body: 'New Body' }
        expect(question.title).to_not eq 'New Title'
        expect(question.body).to_not eq 'New Body'
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      login(user)
    end

    context "author delete his own question" do
      let!(:question) { create(:question, user: user) }

      it 'deletes question from DB' do
        expect { delete :destroy, id: question, format: :json }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
      end
    end

    context "non-author can't delete question" do
      before { question }

      it 'does not delete question from DB' do
        expect { delete :destroy, id: question, format: :json }.to_not change(Question, :count)
      end
    end
  end
end
