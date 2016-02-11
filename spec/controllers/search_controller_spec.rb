require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #search" do
    it "calls sphinx search into Questions" do
      expect(ThinkingSphinx).to receive(:search).with('test', classes: [Question])
      get :search, q: 'test', where: 'Question'
    end

    it "calls sphinx search into Answers" do
      expect(ThinkingSphinx).to receive(:search).with('test', classes: [Answer])
      get :search, q: 'test', where: 'Answer'
    end

    it 'render search template' do
      get :search, q: 'test'
      expect(response).to render_template :search
    end
  end
end