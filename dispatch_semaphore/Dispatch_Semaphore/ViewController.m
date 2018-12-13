//
//  ViewController.m
//  Dispatch_Semaphore
//
//  Created by iMac0 on 2017/4/17.
//  Copyright © 2017年 iMac0. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self asyncTest];
    
    
}


- (void)normalTest{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int index = 0; index < 5; index++) {
        
        dispatch_async(queue, ^(){
       
            [array addObject:[NSNumber numberWithInt:index]];
            
            int value = arc4random() % 100;
            
            float sleep = value / 100.00;
            
            [NSThread sleepForTimeInterval:sleep];
            
            NSLog(@"add index :%d",index);
        });
        
    }
}

- (void)semaphoreTest{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int index = 0; index < 100; index++) {
        
        dispatch_async(queue, ^(){
            dispatch_time_t waitTime = dispatch_time(DISPATCH_TIME_NOW,20 * NSEC_PER_SEC);//有效时间
            dispatch_semaphore_wait(semaphore, waitTime);//这个函数本身就是一个判断函数，只有这个函数通过(有信号)，才会继续往下执行
            
            
            [array addObject:[NSNumber numberWithInt:index]];
            
            int value = arc4random() % 100;
            float sleeper = value / 100.00;
            
            sleep(sleeper);
            
            NSLog(@"add index :%d",index);
            
            dispatch_semaphore_signal(semaphore);
        });
        
    }
}


//控制并发数
- (void)asyncTest{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 10; i++)
    {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(queue, ^{
            NSLog(@"%i",i);
            sleep(2);
            dispatch_semaphore_signal(semaphore);
        });
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
