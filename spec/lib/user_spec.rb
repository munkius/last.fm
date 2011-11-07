require 'spec_helper'

describe LastFM::User do
  include StubResponse

  it "should find a user's top artists" do
    stub_user_response(method: "user.gettopartists", user: "munkius")
    top_artists = LastFM::User.new("munkius").top_artists
    top_artists.size.should == 50
    intwine = top_artists.first
    
    intwine.class.should == LastFM::Artist
    intwine.name.should == "Intwine"
    intwine.url.should == "http://www.last.fm/music/Intwine"
    # intwine.playcount.should == 3194
    intwine.streamable.should be_false
    intwine.images[:small].should == "http://userserve-ak.last.fm/serve/34/3350388.jpg"
    intwine.images[:medium].should == "http://userserve-ak.last.fm/serve/64/3350388.jpg"
    intwine.images[:large].should == "http://userserve-ak.last.fm/serve/126/3350388.jpg"
    intwine.images[:extralarge].should == "http://userserve-ak.last.fm/serve/252/3350388.jpg"
    intwine.images[:mega].should == "http://userserve-ak.last.fm/serve/_/3350388/Intwine+nieuw1.jpg"
  end
end