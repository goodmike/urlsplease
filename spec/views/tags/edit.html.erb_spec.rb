require 'spec_helper'

describe "tags/edit.html.erb" do
  before(:each) do
    @tag = assign(:tag, stub_model(Tag,
      :new_record? => false,
      :contents => "MyString"
    ))
  end

  it "does not render an edit tag form" do
    render

    rendered.should_not have_selector("form", :action => tag_path(@tag), :method => "post") 
  end
end
