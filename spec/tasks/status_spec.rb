require "spec_helper"

describe "status:generate" do
  it "calls StatusGenerator.generate!" do
    StatusMessage.should_receive(:generate_all_users!)
    subject.invoke
  end

  context "integration" do
    context "with an active user" do
      xit "works" do
        subject.invoke
      end
    end
  end
end