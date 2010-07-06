require 'spec_helper'

describe "tags/show.html.erb" do
  before(:each) do
    @tag = assign(:tag, stub_model(Tag,
      :contents => "Contents"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Contents".to_s)
  end
end
