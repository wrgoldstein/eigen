#import "ARFairNetworkModel.h"

@implementation ARFairNetworkModel

- (void)getFairInfo:(Fair *)fair success:(void (^)(Fair *))success failure:(void (^)(NSError *))failure
{
    [ArtsyAPI getFairInfo:fair.fairID success:^(Fair *fair) {

        NSArray *tempMaps = fair.maps;
        [fair mergeValuesForKeysFromModel:fair];
        fair.maps = tempMaps;

        success(fair);

    } failure:failure];
}

- (void)getPostsForFairWithTimeline:(ARFeedTimeline *)timeline success:(void (^)(ARFeedTimeline *))success failure:(void (^)(NSError *))failure
{
    @weakify(timeline);
    [timeline getNewItems:^{
        @strongify(timeline);
        success(timeline);
    } failure:failure];
}

- (void)getOrderedSetsForFair:(Fair *)fair success:(void (^)(NSMutableDictionary *set))success failure:(void (^)(NSError *))failure
{
    [ArtsyAPI getOrderedSetsWithOwnerType:@"Fair" andID:fair.fairID success:success failure:failure];
}

- (void)getMapInfoForFair:(Fair *)fair success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    @weakify(self);

    [ArtsyAPI getMapInfoForFair:fair success:^(NSArray *maps) {
        @strongify(self);
        if (!self) { return; }
        fair.maps = maps;
        if (success) {
            success(maps);
        }
    } failure:failure];
}

- (void)getShowFeedItems:(ARFairShowFeed *)feed success:(void (^)(NSOrderedSet *))success failure:(void (^)(NSError *))failure
{
    [feed getFeedItemsWithCursor:feed.cursor success:success failure:failure];
}

@end



@implementation ARStubbedFairNetworkModel

- (void)getFairInfo:(Fair *)fair success:(void (^)(Fair *))success failure:(void (^)(NSError *))failure
{
    if (self.fair) {
        success(self.fair);
        return;
    }

    if (fair) {
        success(fair);
        return;
    }

    failure(nil);
}

- (void)getPostsForFairWithTimeline:(ARFeedTimeline *)timeline success:(void (^)(ARFeedTimeline *))success failure:(void (^)(NSError *))failure
{
    if (self.timeline) {
        success(self.timeline);
        return;
    }

    if (timeline) {
        success(timeline);
        return;
    }

    failure(nil);
}

- (void)getMapInfoForFair:(Fair *)fair success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    @weakify(self);

    [ArtsyAPI getMapInfoForFair:fair success:^(NSArray *maps) {
        @strongify(self);
        if (!self) { return; }
        fair.maps = maps;
        if (success) {
            success(maps);
        }
    } failure:failure];
}

- (void)getShowFeedItems:(ARFairShowFeed *)feed success:(void (^)(NSOrderedSet *))success failure:(void (^)(NSError *))failure
{
    [feed getFeedItemsWithCursor:feed.cursor success:success failure:failure];
}


@end