# MultithreadingDemo

使用iOS GCD异步任务+并发队列进行图片下载的demo
```
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_async(queue, ^{ 
    ...
}
```

一步一步删除可变数组中的元素
```
-(void) deleteArray{
  NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@"one",@"two",@"three",@"four",@"five"]];
  while (arr.count > 0) {
    [arr removeLastObject];
  }
}
```
