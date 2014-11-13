//
//  MSSBeanController.h
//  EZSMusicalSpoons
//
//  Created by Zeke Shearer on 11/12/14.
//  Copyright (c) 2014 Zeke Shearer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PTDBean.h>

@protocol MSSBeanControllerDelegate;

@interface MSSBeanController : NSObject

@property (nonatomic, assign) id<MSSBeanControllerDelegate> delegate;

- (void)start;
- (void)stop;

@end

@protocol MSSBeanControllerDelegate<NSObject>

- (void)beanController:(MSSBeanController *)beanController didUpdateAxes:(PTDAcceleration)acceleration;

@end
