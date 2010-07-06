require 'spec_helper'

describe "tags/index.html.erb" do
  before(:each) do
    assign(:tags, [
      stub_model(Tag,
        :contents => "Contents"
      ),
      stub_model(Tag,
        :contents => "Contents"
      )
    ])
  end

  it "renders a list of tags" do
    render
    rendered.should have_selector("tr>td", :content => "Contents".to_s, :count => 2)
  end
end
