require 'spec_helper'

describe LastFM::User do
  include StubResponse

  describe "find" do
    it "should retrieve user details" do
      stub_user_response(method: "user.getinfo", user: "munkius")
      munkius = LastFM::User.find("munkius")
      
      munkius.name.should == "Munkius"
      munkius.realname.should == ""
      munkius.images.small.should == "http://userserve-ak.last.fm/serve/34/2487647.jpg"
      munkius.images.medium.should == "http://userserve-ak.last.fm/serve/64/2487647.jpg"
      munkius.images.large.should == "http://userserve-ak.last.fm/serve/126/2487647.jpg"
      munkius.images.extralarge.should == "http://userserve-ak.last.fm/serve/252/2487647.jpg"
      munkius.url.should == "http://www.last.fm/user/Munkius"
      munkius.id.should == 4724243
      munkius.country.should == "NL"
      munkius.age.should == 32
      munkius.gender.should == "m"
      munkius.subscriber.should be_false
      munkius.playcount.should == 47893
      munkius.playlist_count.should == 0
      munkius.bootstrap.should == 0
      munkius.registered.should == DateTime.new(2006, 9, 23, 7, 21)
      munkius.type.should == "user"
    end
    
    it "should return nil when a user does not exist" do
      stub_user_response({method: "user.getinfo", user: "non-existent-user"}, {status: 400})
      LastFM::User.find("non-existent-user").should be_nil
    end
    
    it "should alias find and info" do
      stub_user_response(method: "user.getinfo", user: "munkius")
      LastFM::User.find("munkius").name.should == LastFM::User.info("munkius").name
    end
  end
  
  describe "top artists" do
    
    it "should find a user's top artists" do
      stub_user_response(method: "user.getinfo", user: "munkius")
      stub_user_response(method: "user.gettopartists", user: "Munkius")

      top_artists = LastFM::User.find("munkius").find_top_artists
      top_artists.size.should == 50
      intwine = top_artists.first
    
      intwine.class.should == LastFM::Artist
      intwine.name.should == "Intwine"
      intwine.url.should == "http://www.last.fm/music/Intwine"
      intwine.streamable.should be_false
      intwine.images.small.should == "http://userserve-ak.last.fm/serve/34/3350388.jpg"
      intwine.images.medium.should == "http://userserve-ak.last.fm/serve/64/3350388.jpg"
      intwine.images.large.should == "http://userserve-ak.last.fm/serve/126/3350388.jpg"
      intwine.images.extralarge.should == "http://userserve-ak.last.fm/serve/252/3350388.jpg"
      intwine.images.mega.should == "http://userserve-ak.last.fm/serve/_/3350388/Intwine+nieuw1.jpg"
    end
  end
end