//
//  DownloadImg.h
//  MultithreadingDemo
//
//  Created by 姜冉 on 2020/5/10.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadImg : RCTEventEmitter<RCTBridgeModule,NSURLConnectionDataDelegate,NSURLSessionDelegate>

@end

NS_ASSUME_NONNULL_END
