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

#import "MLIMGURUploader.h"

@implementation MLIMGURUploader

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
          failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock
{
//  NSAssert(imageData, @"Image data is required");
//  NSAssert(clientID, @"Client ID is required");
  
  NSString *urlString = @"http://server.mallteem.com/json/upload.ashx?aim=update";
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
  [request setURL:[NSURL URLWithString:urlString]];
  [request setHTTPMethod:@"POST"];
  
  NSMutableData *requestBody = [[NSMutableData alloc] init];
  
  NSString *boundary = @"*****";
  
  NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;boundary=%@", boundary];
  [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
  
  // Add client ID as authrorization header
//  [request addValue:[NSString stringWithFormat:@"Client-ID %@", clientID] forHTTPHeaderField:@"Authorization"];
  
  // Image File Data
  [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  [requestBody appendData:[@"Content-Disposition: form-data; name=\"Filedata\"; filename=\"balloons.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  
  [requestBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  [requestBody appendData:[NSData dataWithData:imageData]];
  [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  

    /************************************************************************************************************************/
    
  if (userID) {
    [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[userID dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  }
  

  if (pwd) {
    [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"pwd\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[pwd dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  }
    
    if (phone) {
        [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"phone\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[phone dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (name) {
        [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[name dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    if (province) {
        [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"province\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[province dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (city) {
        [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"city\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[city dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    if (county) {
        [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"county\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[county dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    if (area) {
        [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"area\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[area dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    if (email) {
        [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[email dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (bankUser) {
        [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"bankUser\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[bankUser dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    if (bankName) {
        [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"bankName\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[bankName dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (bankCode) {
        [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"bankCode\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[bankCode dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (bankNumber) {
        [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"bankNumber\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[bankNumber dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }


    /************************************************************************************************************************/

    
  [requestBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  
  [request setHTTPBody:requestBody];
  
   
 
    
  [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
      


      
  
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    
      
    NSDictionary *dictionary = [httpResponse allHeaderFields];
    NSLog(@":::1%@",[dictionary description]);
    
      
    NSString * err= [dictionary objectForKey:@"error"];
      
    int statusCode = (int)[httpResponse statusCode];
      
      if (statusCode != 200) {
          NSString *errTitle = [err stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
          
          NSLog(@"errTitle:%@",errTitle);
          
          UIAlertView * av =[[UIAlertView alloc]initWithTitle:errTitle message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
          
          [av show];
          NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
          
          [ud setObject:@"NO" forKey:@"isChangeInfo"];
          
      }else{
          
          UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"修改成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
          
          [av show];
          
          NSString * path = [dictionary objectForKey:@"path"];
          NSLog(@"path:%@",path);
          
          ShareInfo * shareInfo = [ShareInfo shareInstance];
          shareInfo.userModel.uimg = path;
          
          NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
          
          [ud setObject:@"YES" forKey:@"isChangeInfo"];
      }
    NSLog(@"statusCode:%d",statusCode);
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

   
      
    if ([responseDictionary valueForKeyPath:@"data.error"]) {
      if (failureBlock) {
        if (!error) {
          // If no error has been provided, create one based on the response received from the server
          error = [NSError errorWithDomain:@"imguruploader" code:10000 userInfo:@{NSLocalizedFailureReasonErrorKey : [responseDictionary valueForKeyPath:@"data.error"]}];
        }
        failureBlock(response, error, [[responseDictionary valueForKey:@"status"] intValue]);
      }
    } else {
      if (completion) {
        completion([responseDictionary valueForKeyPath:@"data.link"]);
      }
      
    }
    
  }];
}
+ (void)UpInfoFiledata1:(NSData*)imageData1
              Filedata2:(NSData*)imageData2
                 userid:(NSString*)userid
        completionBlock:(void(^)(NSString* result))completion
           failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock
{
    NSString *urlString = @"http://server.mallteem.com/json/upload.ashx?aim=upgrade";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *requestBody = [[NSMutableData alloc] init];
    
    NSString *boundary = @"*****";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    
    [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[@"Content-Disposition: form-data; name=\"Filedata1\"; filename=\"Filedata1.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [requestBody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[NSData dataWithData:imageData1]];
    [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    // Filedata2
    
    [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[@"Content-Disposition: form-data; name=\"Filedata2\"; filename=\"Filedata2.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [requestBody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [requestBody appendData:[NSData dataWithData:imageData2]];
    [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // userid
    
    if (userid) {
        [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[userid dataUsingEncoding:NSUTF8StringEncoding]];
        [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestBody length]];
    NSLog(@"postLength:%@",postLength);
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    /************************************************************************************************************************/
    
    
    [requestBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:requestBody];

    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        NSLog(@":::2%@",[dictionary description]);
        
//        NSString * err= [dictionary objectForKey:@"error"];
//        
//        NSString *errTitle = [err stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        
//        NSLog(@"errTitle:%@",errTitle);
//        
//        UIAlertView * av =[[UIAlertView alloc]initWithTitle:errTitle message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        
//        [av show];
        

        int statusCode = (int)[httpResponse statusCode];
        NSLog(@"statusCode:%d",statusCode);
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"responseDictionary:%@",responseDictionary);
        
        if ([responseDictionary valueForKeyPath:@"data.error"]) {
            if (failureBlock) {
                if (!error) {
                    // If no error has been provided, create one based on the response received from the server
                    error = [NSError errorWithDomain:@"imguruploader" code:10000 userInfo:@{NSLocalizedFailureReasonErrorKey : [responseDictionary valueForKeyPath:@"data.error"]}];
                }
                failureBlock(response, error, [[responseDictionary valueForKey:@"status"] intValue]);
            }
        } else {
            if (completion) {
                completion([responseDictionary valueForKeyPath:@"data.link"]);
            }
            
        }
        
    }];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    NSLog(@"newdata:%@",data);
}
@end
