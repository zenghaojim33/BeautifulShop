//
//  BWMProductPutawayPostModel.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/15.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief  上下架类型
 */
typedef NS_ENUM(NSInteger, BWMProductPutawayPostModelType){
    /**
     *  @brief  上架
     */
    BWMProductPutawayPostModelTypeAdd,
    /**
     *  @brief  下架
     */
    BWMProductPutawayPostModelTypeDel
};

/**
 *  @brief  上下架Post请求Model
 */
@interface BWMProductPutawayPostModel : NSObject

@property (strong, nonatomic, readonly) NSString *userID;
@property (assign, nonatomic) BWMProductPutawayPostModelType type;
@property (strong, nonatomic, readonly) NSArray *productsID;

- (void)addProductID:(NSString *)productID;
- (NSDictionary *)postDictionary;

+ (NSString *)API;

+ (instancetype)modelWithType:(BWMProductPutawayPostModelType)type;

@end
