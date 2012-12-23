require 'spec_helper'

describe DiagDown::Render::SVG do
  before :each do
    @renderer = DiagDown::Render::SVG.new
  end

  describe "#new" do
    it "takes no parameters and returns an SVG object" do
      @renderer.should be_an_instance_of DiagDown::Render::SVG
    end
  end

  it "renders a simple arrow between 2 timelines" do
    @renderer.arrow('Alice', 'Bob', 'text')
    @renderer.render
#    @renderer.to_file('/tmp/test.svg')
  end

  it "renders multiple arrows between 3 timelines" do
    @renderer.arrow('Alice', 'Bob', 'text')
    @renderer.arrow('Bob', 'John', 'other text')
    @renderer.arrow('John', 'Alice', 'yet another text')
    @renderer.render
    @renderer.to_file('/tmp/test.svg')
  end

end
