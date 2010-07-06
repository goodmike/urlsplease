require 'spec_helper'

describe "tags/new.html.erb" do
  before(:each) do
    assign(:tag, stub_model(Tag,
      :new_record? => true,
      :contents => "MyString"
    ))
  end

  it "renders new tag form" do
    render

    rendered.should have_selector("form", :action => tags_path, :method => "post") do |form|
      form.should have_selector("input#tag_contents", :name => "tag[contents]")
    end
  end
end
