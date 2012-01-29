require 'spec_helper'

describe LastFM::Event do
  include StubResponse
  
  it "should be findable" do
    stub_event_response(method: "event.getinfo", event: "3110217")
    event = LastFM::Event.find(3110217)

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
    # event.tags.should == ["dutch", "singer-songwriter", "alternative"]
  end
  
end
