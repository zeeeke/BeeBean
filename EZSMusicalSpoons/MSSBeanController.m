//
//  MSSBeanController.m
//  EZSMusicalSpoons
//
//  Created by Zeke Shearer on 11/12/14.
//  Copyright (c) 2014 Zeke Shearer. All rights reserved.
//

#import "MSSBeanController.h"
#import <PTDBeanManager.h>

@interface MSSBeanController ()  <PTDBeanManagerDelegate, PTDBeanDelegate>

@property (nonatomic, strong) PTDBeanManager *beanManager;
@property (nonatomic, strong) PTDBean *bean;
@property (nonatomic, strong) NSTimer *updateTimer;

@end

@implementation MSSBeanController

- (id)init
{
    self = [super init];
    if ( self ) {
        self.beanManager = [[PTDBeanManager alloc] initWithDelegate:self];
    }
    return self;
}

- (void)start
{
    [self.beanManager startScanningForBeans_error:nil];
}

- (void)stop
{
    [self.beanManager disconnectBean:self.bean error:nil];
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}

- (void)startTimer
{
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(readBean:) userInfo:nil repeats:YES];
}

- (void)readBean:(id)sender
{
    [self.bean readAccelerationAxes];
}

#pragma mark - BeanManagerDelegate Callbacks

- (void)beanManagerDidUpdateState:(PTDBeanManager *)manager
{
    
}

- (void)BeanManager:(PTDBeanManager*)beanManager didDiscoverBean:(PTDBean*)bean error:(NSError*)error
{
    if ( [bean.name isEqualToString:@"Bean"] ) {
        [self.beanManager connectToBean:bean error:nil];
    }
}

- (void)BeanManager:(PTDBeanManager*)beanManager didConnectToBean:(PTDBean*)bean error:(NSError*)error
{
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    [self.beanManager stopScanningForBeans_error:&error];
    self.bean = bean;
    self.bean.delegate = self;
    [self startTimer];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
}

#pragma mark BeanDelegate

- (void)bean:(PTDBean*)bean didUpdateAccelerationAxes:(PTDAcceleration)acceleration
{
    [self.delegate beanController:self didUpdateAxes:acceleration];
}


@end
