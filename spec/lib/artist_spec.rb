# encoding: utf-8
require 'spec_helper'

describe LastFM::Artist do
  include StubResponse

  describe "search" do

    describe "for Tool" do
      before :each do
        stub_response(method: "artist.search", artist: "tool")
        @artists = LastFM::Artist.search('tool')
      end
    
      it "should find Tool" do
        @artists.size.should == 30
        tool = @artists .first

        tool.name.should == "Tool"
        tool.listeners.should == 1332090
        tool.url.should == "http://www.last.fm/music/Tool"
        tool.streamable.should be_true
      
        tool.images.size.should == 5
        tool.images[:small].should == "http://userserve-ak.last.fm/serve/34/3727739.jpg"
        tool.images[:medium].should == "http://userserve-ak.last.fm/serve/64/3727739.jpg"
        tool.images[:large].should == "http://userserve-ak.last.fm/serve/126/3727739.jpg"
        tool.images[:extralarge].should == "http://userserve-ak.last.fm/serve/252/3727739.jpg"
        tool.images[:mega].should == "http://userserve-ak.last.fm/serve/500/3727739/Tool+1199177781240.jpg"
      end
    
      it "should de-encode content" do
        tool_and_friends = @artists.select{|a| a.name == "Tool, Staind, Korn & Chevelle" }.first
        tool_and_friends.listeners.should == 310
        tool_and_friends.streamable.should == false
      end
    end
    
    describe "for artists with spaces and funny characters in their name" do
      
      it "should find mumford & sons" do
        stub_response(method: "artist.search", artist: "mumford & sons")
        artists = LastFM::Artist.search('mumford & sons')
        artists.size.should == 30
        artists.first.name.should == "Mumford & Sons"
      end

      it "should find bløf" do
        stub_response(method: "artist.search", artist: "bløf")
        artists = LastFM::Artist.search('bløf')
        artists.size.should == 30
        artists.first.name.should == "Bløf"
      end
      
    end
  end
end
