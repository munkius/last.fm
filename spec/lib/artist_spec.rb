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
        tool = @artists.first

        tool.name.should == "Tool"
        tool.listeners.should == 1332090
        tool.url.should == "http://www.last.fm/music/Tool"
        tool.streamable?.should be_true
      
        tool.images.size.should == 5
        tool.images.small.should == "http://userserve-ak.last.fm/serve/34/3727739.jpg"
        tool.images.medium.should == "http://userserve-ak.last.fm/serve/64/3727739.jpg"
        tool.images.large.should == "http://userserve-ak.last.fm/serve/126/3727739.jpg"
        tool.images.extralarge.should == "http://userserve-ak.last.fm/serve/252/3727739.jpg"
        tool.images.mega.should == "http://userserve-ak.last.fm/serve/500/3727739/Tool+1199177781240.jpg"
      end
    
      it "should de-encode content" do
        tool_and_friends = @artists.select{|a| a.name == "Tool, Staind, Korn & Chevelle" }.first
        tool_and_friends.listeners.should == 310
        tool_and_friends.streamable?.should == false
      end
    end
    
    describe "for artists with spaces and funny characters in their name" do
      it "should find mumford & sons" do
        stub_artist_response(method: "artist.search", artist: 'mumford & sons')
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
    
    describe "for artists with limited info" do
      it "should find the wheepies" do
        stub_artist_response(method: "artist.search", artist: "wheepies")
        artists = LastFM::Artist.search('wheepies')
        artists.size.should == 1
        artists.first.name.should == "Wheepies"
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

  describe "find" do
    
    it "should be found for Tool" do
      stub_artist_response(method: "artist.getinfo", artist: "tool", autocorrect: 1)
      tool = LastFM::Artist.find("tool")
      tool.name.should == "Tool"
      tool.listeners.should == 1332090
      tool.mbid.should == "66fc5bf8-daa4-4241-b378-9bc9077939d2"
      tool.url.should == "http://www.last.fm/music/Tool"
      tool.streamable?.should be_true
    
      tool.images.size.should == 5
      tool.images.small.should == "http://userserve-ak.last.fm/serve/34/3727739.jpg"
      tool.images.medium.should == "http://userserve-ak.last.fm/serve/64/3727739.jpg"
      tool.images.large.should == "http://userserve-ak.last.fm/serve/126/3727739.jpg"
      tool.images.extralarge.should == "http://userserve-ak.last.fm/serve/252/3727739.jpg"
      tool.images.mega.should == "http://userserve-ak.last.fm/serve/500/3727739/Tool+1199177781240.jpg"
      
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
      blof = LastFM::Artist.find("blof")
      blof.name.should == "Bløf"
    end
    
    it "should return nil when an artist does not exist" do
      stub_artist_response({method: "artist.getinfo", artist: "non-existent-artist", autocorrect: 1}, {status: 400})
      LastFM::Artist.find("non-existent-artist").should be_nil
    end
    
    it "should alias find and info" do
      stub_artist_response(method: "artist.getinfo", artist: "tool", autocorrect: 1)
      LastFM::Artist.find("tool").name.should == LastFM::Artist.info("tool").name
    end

  end
  
  describe "top tracks" do
    
    it "should be found for Tool" do
      stub_artist_response(method: "artist.getinfo", artist: "tool", autocorrect: 1)
      stub_artist_response(method: "artist.gettoptracks", artist: "Tool", autocorrect: 1)
      top_tracks = LastFM::Artist.find("tool").find_top_tracks
      
      top_tracks.size.should == 50
      schism = top_tracks.first
      schism.rank.should == 1
      schism.name.should == "Schism"
      schism.duration.should == 407
      schism.playcount.should == 198814
      schism.listeners.should == 65068
      schism.url.should == "http://www.last.fm/music/Tool/_/Schism"
      schism.streamable.should be_true

      schism.images.small.should == "http://userserve-ak.last.fm/serve/34s/69544646.png" 
      schism.images.medium.should == "http://userserve-ak.last.fm/serve/64s/69544646.png"
      schism.images.large.should == "http://userserve-ak.last.fm/serve/126/69544646.png"
      schism.images.extralarge.should == "http://userserve-ak.last.fm/serve/300x300/69544646.png"
    end
    
    it "should use autocorrection" do
      stub_artist_response(method: "artist.getinfo", artist: "blof", autocorrect: 1)
      stub_artist_response(method: "artist.gettoptracks", artist: "Bløf")
      stub_artist_response(method: "artist.gettoptracks", artist: "Bløf", autocorrect: 1)
      top_tracks = LastFM::Artist.find("blof").find_top_tracks
      top_tracks.first.name.should == "Harder Dan Ik Hebben Kan"
    end
  end
  
  describe "events" do
    
    it "should be found for de staat" do
      stub_artist_response(method: "artist.getinfo", artist: "de staat", autocorrect: 1)
      stub_artist_response(method: "artist.getevents", artist: "De Staat", autocorrect: 1)
      de_staat = LastFM::Artist.find("de staat")
      events = de_staat.find_events
      
      events.size.should == 19
      event = events.first

      event.id.should == "3110217"
      event.title.should == "De Staat"
      event.headliner.should == "De Staat"
      event.artists.should == ["De Staat", "Ulysses Storm"]
      event.venue.id.should == "8777933"
      event.venue.name.should == "Old Blue Last"
      event.venue.location.city.should == "London"
      event.venue.location.country.should == "United Kingdom"
      event.venue.location.street.should == "38 Great Eastern Street"
      event.venue.location.postalcode.should == "EC2A 3ES"
      event.venue.location.geo.lat.should == 51.524306
      event.venue.location.geo.long.should == -0.079993
      event.venue.url.should == "http://www.last.fm/venue/8777933+Old+Blue+Last"
      event.venue.website.should == "http://theOldBlueLast.com/listings"
      event.venue.phonenumber.should == "+44-(0)20-7739 7033"
      event.venue.images.small.should == "http://userserve-ak.last.fm/serve/34/2779207.jpg"
      event.venue.images.medium.should == "http://userserve-ak.last.fm/serve/64/2779207.jpg"
      event.venue.images.large.should == "http://userserve-ak.last.fm/serve/126/2779207.jpg"
      event.venue.images.extralarge.should == "http://userserve-ak.last.fm/serve/252/2779207.jpg"
      event.venue.images.mega.should == "http://userserve-ak.last.fm/serve/_/2779207/Old+Blue+Last+blue.jpg"
      event.start_date.should == DateTime.new(2011, 11, 8, 20, 0, 0)
      event.description.should == ""
      event.images.small.should == "http://userserve-ak.last.fm/serve/34/16449437.jpg"
      event.images.medium.should == "http://userserve-ak.last.fm/serve/64/16449437.jpg"
      event.images.large.should == "http://userserve-ak.last.fm/serve/126/16449437.jpg"
      event.images.extralarge.should == "http://userserve-ak.last.fm/serve/252/16449437.jpg"
      event.attendance.should == 1
      event.reviews = 0
      event.tag.should == "lastfm:event=3110217"
      event.url.should == "http://www.last.fm/event/3110217+De+Staat+at+Old+Blue+Last+on+8+November+2011"
      event.website.should == ""
      # TODO: event.tickets.should == ""
      event.cancelled.should be_false
      event.tags.should == ["dutch", "singer-songwriter", "alternative"]
    end
  end

  describe "similar" do
    before :each do
      stub_artist_response(method: "artist.getinfo", artist: "tool", autocorrect: 1)
      stub_artist_response(method: "artist.getsimilar", artist: "Tool")
      @tool = LastFM::Artist.find("tool")
    end
    
    it "should find similar artists" do
      similar = @tool.find_similar_artists
      similar.size.should == 100

      a_perfect_circle = similar.first
      a_perfect_circle.name.should == "A Perfect Circle"
      a_perfect_circle.match.should == 1
      a_perfect_circle.url.should == "www.last.fm/music/A+Perfect+Circle"
      a_perfect_circle.images.large.should == "http://userserve-ak.last.fm/serve/126/139730.jpg"
      a_perfect_circle.streamable?.should be_true
    end
    
    
  end

  describe "past events" do
    before :each do
      stub_artist_response(method: "artist.getinfo", artist: "deftones", autocorrect: 1)
      stub_artist_response(method: "artist.getpastevents", artist: "Deftones")
      @deftones = LastFM::Artist.find("deftones")
    end
    
    it "should be found for Deftones" do
      past_events = @deftones.find_past_events
      past_events.size.should == 50
      paradiso_event = past_events.select{|e| e.venue.name == "Paradiso"}.first
      paradiso_event.artists.should == ["Deftones", "Animals As Leaders"]
      paradiso_event.attendance.should == 149
      # the rest is tested through the events spec
    end
  end
  
  describe "top fans" do
    before :each do
      stub_artist_response(method: "artist.getinfo", artist: "deftones", autocorrect: 1)
      stub_artist_response(method: "artist.gettopfans", artist: "Deftones")
      @deftones = LastFM::Artist.find("deftones")
    end
    
    it "should be found for Deftones" do
      top_fans = @deftones.find_top_fans
      top_fans.size.should == 50
      kyyn = top_fans.first
      kyyn.name.should == "Kyyn"
      kyyn.realname.should == ""
      kyyn.url.should == "http://www.last.fm/user/Kyyn"
      kyyn.weight.should == 300124992
    end
  end

  describe "top albums" do
    before :each do
      stub_artist_response(method: "artist.getinfo", artist: "deftones", autocorrect: 1)
      stub_artist_response(method: "artist.gettopalbums", artist: "Deftones")
      @deftones = LastFM::Artist.find("deftones")
    end
    
    it "should be found for Deftones" do
      top_albums = @deftones.find_top_albums
      top_albums.size.should == 50
      deftones_album = top_albums.first

      deftones_album.rank.should == 1
      deftones_album.name.should == "Deftones"
      deftones_album.playcount.should == 489670
      deftones_album.url.should == "http://www.last.fm/music/Deftones/Deftones"
      deftones_album.artist.name.should == "Deftones"
      deftones_album.artist.url.should == "http://www.last.fm/music/Deftones"
      deftones_album.images.large.should == "http://userserve-ak.last.fm/serve/126/61736359.png"
    end
  end

  describe "top tags" do
    before :each do
      stub_artist_response(method: "artist.getinfo", artist: "deftones", autocorrect: 1)
      stub_artist_response(method: "artist.gettoptags", artist: "Deftones")
      @deftones = LastFM::Artist.find("deftones")
    end
    
    it "should be found for Deftones" do
      top_tags = @deftones.find_top_tags
      top_tags.size.should == 100
      top_tag = top_tags.first
      top_tag.name.should == "metal"
      top_tag.url.should == "http://www.last.fm/tag/metal"
    end
  end

  describe "images" do
    before :each do
      stub_artist_response(method: "artist.getinfo", artist: "deftones", autocorrect: 1)
      stub_artist_response(method: "artist.getimages", artist: "Deftones")
      @deftones = LastFM::Artist.find("deftones")
    end
    
    it "should be found for Deftones" do
      images = @deftones.find_images
      images.size.should == 50
      image = images.first
      
      image.title.should == "Deftones - Diamond Eyes 2010"
      image.url.should == "http://www.last.fm/music/Deftones/+images/44107199"
      image.date_added.should == DateTime.new(2010, 3, 26, 23, 48, 13)
      image.format.should == "jpg"
      image.sizes.original.should == "http://userserve-ak.last.fm/serve/_/44107199/Deftones+++Diamond+Eyes+2010.jpg"
      image.sizes.large.should == "http://userserve-ak.last.fm/serve/126/44107199.jpg"
      image.votes.thumbsup.should == 190
      image.votes.thumbsdown.should == 64
    end
    
    pending "should be possible to give a limit"
  end

  describe "shouts" do
    before :each do
      stub_artist_response(method: "artist.getinfo", artist: "deftones", autocorrect: 1)
      stub_artist_response(method: "artist.getshouts", artist: "Deftones")
      @deftones = LastFM::Artist.find("deftones")
    end
    
    it "should be found for Deftones" do
      shouts = @deftones.find_shouts
      shouts.size.should == 50
      shout = shouts.last
      
      shout.body.should == "You've Seen the Butcher doesn't sound as their typical song. Deftones playing DOOM there. rest of album is full of fillers though"
      shout.author.should == "xdreamx19"
      shout.date.should == DateTime.new(2011, 10, 24, 15, 53, 20)
    end
    
    pending "should be possible to give a limit"
    
  end


end
