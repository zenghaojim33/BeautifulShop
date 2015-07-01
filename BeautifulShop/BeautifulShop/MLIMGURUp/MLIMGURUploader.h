// Copyright 2013 Matt Long http://www.cimgf.com/
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

@protocol MLIMGURUpploaderDelegate;

#import <Foundation/Foundation.h>

@interface MLIMGURUploader : NSObject

//+ (void)uploadPhoto:(NSData*)imageData
//              title:(NSString*)title
//        description:(NSString*)description
//      imgurClientID:(NSString*)clientID
//    completionBlock:(void(^)(NSString* result))completion
//       failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock;

@property(nonatomic,strong)id<MLIMGURUpploaderDelegate>delegate;
+ (void)ChangeUserInfo:(NSData*)imageData
             userID:(NSString*)userID
                pwd:(NSString*)pwd
                   phone:(NSString*)phone
                  name:(NSString*)name
           province:(NSString*)province
               city:(NSString*)city
             county:(NSString*)county
               area:(NSString*)area
              email:(NSString*)email
           bankUser:(NSString*)bankUser
           bankName:(NSString*)bankName
           bankCode:(NSString*)bankCode
            bankNumber:(NSString *)bankNumber
      imgurClientID:(NSString*)clientID
    completionBlock:(void(^)(NSString* result))completion
       failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock;

+ (void)UpInfoFiledata1:(NSData*)imageData1
              Filedata2:(NSData*)imageData2
                userid:(NSString*)userid
       completionBlock:(void(^)(NSString* result))completion
          failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock;

@end
@protocol MLIMGURUpploaderDelegate <NSObject>

-(void)setChangeBool:(BOOL)isYes;

@end