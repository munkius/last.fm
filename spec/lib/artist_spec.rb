# encoding: utf-8
require 'spec_helper'

describe LastFM::Artist do
  include StubResponse

  describe "search" do

    describe "for Tool" do
      before :each do
        stub_artist_response(method: "artist.search", artist: "tool")
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
        stub_artist_response(method: "artist.search", artist: "mumford & sons")
        artists = LastFM::Artist.search('mumford & sons')
        artists.size.should == 30
        artists.first.name.should == "Mumford & Sons"
      end

      it "should find bløf" do
        stub_artist_response(method: "artist.search", artist: "bløf")
        artists = LastFM::Artist.search('bløf')
        artists.size.should == 30
        artists.first.name.should == "Bløf"
      end
    end
    
    pending "error handling"
    
    # 2 : Invalid service - This service does not exist
    # 3 : Invalid Method - No method with that name in this package
    # 4 : Authentication Failed - You do not have permissions to access the service
    # 5 : Invalid format - This service doesn't exist in that format
    # 6 : Invalid parameters - Your request is missing a required parameter
    # 7 : Invalid resource specified
    # 8 : Operation failed - Something else went wrong
    # 9 : Invalid session key - Please re-authenticate
    # 10 : Invalid API key - You must be granted a valid key by last.fm
    # 11 : Service Offline - This service is temporarily offline. Try again later.
    # 13 : Invalid method signature supplied
    # 16 : There was a temporary error processing your request. Please try again
    # 26 : Suspended API key - Access for your account has been suspended, please contact Last.fm
    # 29 : Rate limit exceeded - Your IP has made too many requests in a short period
  end

  describe "info" do
    
    it "should be found for Tool" do
      stub_artist_response(method: "artist.getinfo", artist: "tool", autocorrect: 1)
      tool = LastFM::Artist.new("tool")
      tool.name.should == "tool"
      
      tool.info!
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
      
      similar_artists = ["A Perfect Circle", "Puscifer", "Rishloo", "ASHES dIVIDE", "Nine Inch Nails"]

      tool.similar_artists.size.should == similar_artists.size
      similar_artists.each {|a| tool.similar_artists.should include(a)}
      
      tags = ["progressive metal", "progressive rock", "metal", "alternative", "rock"]
      tool.tags.size.should == tags.size
      tags.each{|t| tool.tags.should include(t)}
    end
    
    it "should use autocorrection" do
      stub_artist_response(method: "artist.getinfo", artist: "blof")
      stub_artist_response(method: "artist.getinfo", artist: "blof", autocorrect: 1)
      blof = LastFM::Artist.new("blof").info!
      blof.name.should == "Bløf"
    end
  end
  
  describe "top tracks" do
    
    it "should be found for Tool" do
      stub_artist_response(method: "artist.gettoptracks", artist: "tool", autocorrect: 1)
      top_tracks = LastFM::Artist.new("tool").top_tracks
      
      top_tracks.size.should == 50
      schism = top_tracks.first
      schism.rank.should == 1
      schism.name.should == "Schism"
      schism.duration.should == 407
      schism.playcount.should == 198814
      schism.listeners.should == 65068
      schism.url.should == "http://www.last.fm/music/Tool/_/Schism"
      schism.streamable.should be_true

      schism.images[:small].should == "http://userserve-ak.last.fm/serve/34s/69544646.png" 
      schism.images[:medium].should == "http://userserve-ak.last.fm/serve/64s/69544646.png"
      schism.images[:large].should == "http://userserve-ak.last.fm/serve/126/69544646.png"
      schism.images[:extralarge].should == "http://userserve-ak.last.fm/serve/300x300/69544646.png"
    end
    
    it "should use autocorrection" do
      stub_artist_response(method: "artist.gettoptracks", artist: "blof")
      stub_artist_response(method: "artist.gettoptracks", artist: "blof", autocorrect: 1)
      top_tracks = LastFM::Artist.new("blof").top_tracks
      top_tracks.first.name.should == "Harder Dan Ik Hebben Kan"
    end
  end
  
end
