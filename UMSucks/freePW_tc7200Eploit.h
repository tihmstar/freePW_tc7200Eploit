//
//  freePW_tc7200Eploit.h
//  freePW_tc7200Eploit
//
//  Created by tihm on 03.07.14.
//  Copyright (c) 2014 tihmstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface freePW_tc7200Eploit : NSObject

+(NSArray *)getLoginData:(NSString *)gateway; // [username,pass]
+(NSString *)getIPAddressGateway;

@end
