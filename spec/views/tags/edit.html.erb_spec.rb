require 'spec_helper'

describe "tags/edit.html.erb" do
  before(:each) do
    @tag = assign(:tag, stub_model(Tag,
      :new_record? => false,
      :contents => "MyString"
    ))
  end

  it "renders the edit tag form" do
    render

    rendered.should have_selector("form", :action => tag_path(@tag), :method => "post") do |form|
      form.should have_selector("input#tag_contents", :name => "tag[contents]")
    end
  end
end
