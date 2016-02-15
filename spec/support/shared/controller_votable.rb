shared_examples_for "Controller Votable" do
  describe "POST /vote_up" do
    before { login(user) }

    it "calls #vote_up method" do
      allow(subject.class).to receive(:find).and_return(subject)
      expect(subject).to receive(:vote_up).with(user)
      post :vote_up, id: subject
    end
  end

  describe "POST /vote_down" do
    before { login(user) }

    it "calls #vote_down method" do
      allow(subject.class).to receive(:find).and_return(subject)
      expect(subject).to receive(:vote_down).with(user)
      post :vote_down, id: subject
    end
  end
end