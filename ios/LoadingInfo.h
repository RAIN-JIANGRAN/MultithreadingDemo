//
//  LoadingInfo.h
//  MultithreadingDemo
//
//  Created by 姜冉 on 2020/5/10.
//

#import <Foundation/Foundation.h>
@interface LoadingInfo : NSObject

@property long long totalLength;
@property long long receivedLength;
@property NSString *fileName;
@property NSString *url;
@property NSMutableData *data;

@end
