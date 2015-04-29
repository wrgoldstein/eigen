#import "ARFairAwareObject.h"
#import "ARFairArtistViewController.h"
#import "ARFairArtistNetworkModel.h"
#import "Map.h"

@interface ARFairArtistViewController (Tests)
@property (nonatomic, assign, readwrite) BOOL shouldAnimate;
@property (nonatomic, strong, readwrite) NSObject <FairArtistNeworkModel> *networkModel;
@end

SpecBegin(ARFairArtistViewController)

void (^itlooksCorrectWithArtist)(Artist* artist, NSArray *maps) = ^void(Artist *artist, NSArray *mapsJSON) {

    Fair *fair = [Fair modelWithJSON:@{
        @"id" : @"fair-id",
        @"name" : @"The Armory Show",
        @"organizer" : @{ @"profile_id" : @"fair-profile-id" },
    }];
    
    id fairMock = [OCMockObject partialMockForObject:fair];
    NSArray *maps = [mapsJSON map:^Map*(NSDictionary *mapJSON) { return [Map modelWithJSON:mapJSON]; }];
    [[[fairMock stub] andReturn:maps] maps];

    [OHHTTPStubs stubJSONResponseAtPath:@"/api/v1/maps" withParams:@{ @"fair_id" : @"fair-id" } withResponse:mapsJSON];

    ARStubbedFairArtistNetworkModel *model = [[ARStubbedFairArtistNetworkModel alloc] init];
    model.artist = artist;
    model.shows = @[];

    ARFairArtistViewController *fairArtistVC = [[ARFairArtistViewController alloc] initWithArtistID:@"some-artist" fair:fairMock];
    fairArtistVC.networkModel = model;
    [fairArtistVC ar_presentWithFrame:CGRectMake(0, 0, 320, 480)];
    expect(fairArtistVC.view).will.haveValidSnapshot();

};

sharedExamples(@"looks correct", ^(NSDictionary *data) {
    __block NSArray *mapsJSON = data[@"mapsJSON"];

    it(@"show subtitle with a birthdate and a nationality", ^{
        Artist *artist = [Artist modelWithJSON:@{ @"id" : @"some-artist", @"name" : @"Some Artist", @"birthday" : @"1999", @"nationality" : @"Chinese"}];
        itlooksCorrectWithArtist(artist, mapsJSON);
    });

    it(@"hides subtitle without a birthdate", ^{
        Artist *artist = [Artist modelWithJSON:@{ @"id" : @"some-artist", @"name" : @"Some Artist", @"nationality" : @"Chinese"}];
        itlooksCorrectWithArtist(artist, mapsJSON);
    });

    it(@"hides subtitle without a nationality", ^{
        Artist *artist = [Artist modelWithJSON:@{ @"id" : @"some-artist", @"name" : @"Some Artist", @"birthday" : @"1999"}];
        itlooksCorrectWithArtist(artist, mapsJSON);
    });

});

describe(@"with maps", ^{
    itBehavesLike(@"looks correct", @{@"mapsJSON": @[@{ @"id" : @"map-id" }] });
});

describe(@"without maps", ^{
    itBehavesLike(@"looks correct", @{@"mapsJSON": @[] });
});

SpecEnd
