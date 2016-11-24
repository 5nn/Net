# Networking
Networking


使用提醒：
1:如果是简单的非缓存请求直接用Networking.
2:如果有请求依赖，请求缓存，请求字符串处理等用ytknetworking。

不用第三方库也可以，用：
   （默认的配置会将缓存存储在磁盘上）
   NSURLSession *ses = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
  如果需要放入队列中操作，
 [ NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                      delegate:self
                                                 delegateQueue:[[NSOperationQueue alloc] init]]//队列自行设置，建议用ytknetworking
                                                 
                                                ／／ NSOperationQueue 底层封装gcd
                                                 
   //[self.request setValue:self.localLastModified forHTTPHeaderField:@"If-Modified-Since"];设置头信息可以在request里面
  
  NSURLSessionDataTask *task = [ses dataTaskWithRequest:self.request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
  
    // 子线程执行
   xxxx
   
    dispatch_async(dispatch_get_main_queue(), ^{
          //xxxxxx
        });
}];
 
 [task resume];
  
