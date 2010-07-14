require 'spec_helper'

describe "tags/new.html.erb" do
  before(:each) do
    assign(:tag, stub_model(Tag,
      :new_record? => true,
      :contents => "MyString"
    ))
  end

  it "does not render new tag form" do
    render

    rendered.should_not have_selector("form", :action => tags_path, :method => "post")
  end
end
