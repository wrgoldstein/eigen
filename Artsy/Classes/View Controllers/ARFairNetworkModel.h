@interface ARFairNetworkModel : NSObject
- (void)getFairInfo:(NSString *)fairID success:(void (^)(Fair *fair))success failure:(void (^)(NSError *error))failure;

- (void)getShowFeedItems:(ARFairShowFeed *)feed success:(void (^)(NSOrderedSet *))success failure:(void (^)(NSError *))failure;

- (void)getPostsForFairWithTimeline:(ARFeedTimeline *)timeline success:(void (^)(ARFeedTimeline *))success failure:(void (^)(NSError *error))failure;

- (void)getOrderedSetsForFair:(Fair *)fair success:(void (^)(NSMutableDictionary *))success failure:(void (^)(NSError *error))failure;

- (void)getMapInfoForFair:(Fair *)fair success:(void (^)(NSArray *maps))success failure:(void (^)(NSError *error))failure;

@end

@interface ARStubbedFairNetworkModel : ARFairNetworkModel

@property (nonatomic, strong, readwrite) Fair *fair;
@property (nonatomic, strong, readwrite) ARFairShowFeed *feed;
@property (nonatomic, strong, readwrite) ARFeedTimeline *timeline;

@end