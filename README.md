# DBLTimer
封装的GCD定时器
## 用法
### 创建定时器

```
#import "DBLTimer.h"
@property (nonatomic, copy) NSString *task;

self.task = [DBLTimer execTask:^{
   //执行任务
} start: interval: repeats: async:];
```

### 取消定时器
```
[DBLTimer cancelTask:self.task];
```
