//
//  DownloadImg.m
//  MultithreadingDemo
//
//  Created by 姜冉 on 2020/5/10.
//

#import "DownloadImg.h"
#import "LoadingInfo.h"


@interface DownloadImg()

@property (strong) NSMutableArray *downloadingInfo;


@end

@implementation DownloadImg



RCT_EXPORT_MODULE(DownloadImg)

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"EventDownload"];
}


RCT_EXPORT_METHOD(download:(NSArray *)imgurl){
  _downloadingInfo = [[NSMutableArray alloc] initWithCapacity:imgurl.count];
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  for(id url in imgurl){
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObject:url forKey:@"url"];
    [_downloadingInfo addObject:dic];
    
    dispatch_async(queue, ^{
      // 1.创建 NSURLSessionConfiguration
      NSURLSessionConfiguration *backgroundConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier: @"com.myapp.networking.background"];
      
      NSOperationQueue *operationQueue = [NSOperationQueue currentQueue];
      
      NSURLSession *backgroundSession = [NSURLSession sessionWithConfiguration:backgroundConfiguration delegate:self delegateQueue:operationQueue];

      // 3.创建 NSURLSessionDownloadTask
      NSURLSessionDownloadTask *downloadTask = [backgroundSession downloadTaskWithURL:[NSURL URLWithString:url]];
      [downloadTask resume];
      
    });
  }
}

//# prama mark - Delegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{

  for(int i = 0 ;i<_downloadingInfo.count;i++){
    NSMutableDictionary *obj = _downloadingInfo[i];
    if([obj objectForKey:@"url"] == downloadTask.originalRequest.URL.absoluteString){
      [obj setObject:[[NSString alloc] initWithFormat:@"%lld",totalBytesWritten] forKey:@"receivedLength"];
      [obj setObject:[[NSString alloc] initWithFormat:@"%lld",totalBytesExpectedToWrite] forKey:@"totalLength"];
      [self sendEventWithName:@"EventDownload" body:_downloadingInfo];
    }
  }
    
}
 
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    for(int i = 0 ;i<_downloadingInfo.count;i++){
       NSMutableDictionary *obj = _downloadingInfo[i];
       if([obj objectForKey:@"url"] == downloadTask.originalRequest.URL.absoluteString){
         
         [obj setObject:[[NSString alloc] initWithFormat:@"%lld",expectedTotalBytes] forKey:@"totalLength"];
        
       }
     }
}
 
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"Session %@ download task %@ finished downloading to URL %@\n", session, downloadTask, location);
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:location error:nil];
    NSString *base64String =[[fileHandle readDataToEndOfFile] base64EncodedStringWithOptions:0];
  [fileHandle closeFile];
    for(int i = 0 ;i<_downloadingInfo.count;i++){
      NSMutableDictionary *obj = _downloadingInfo[i];
      if([obj objectForKey:@"url"] == downloadTask.originalRequest.URL.absoluteString){
        [obj setObject:[[NSString alloc] initWithFormat:@"%@",base64String] forKey:@"base64Data"];
        [self sendEventWithName:@"EventDownload" body:_downloadingInfo];
      }
    }

}


-(void) deleteArray{
  NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@"one",@"two",@"three",@"four",@"five"]];
  while (arr.count > 0) {
    [arr removeLastObject];
  }

}

@end
