//
//  ViewController.m
//  UMSucks
//
//  Created by tihm on 03.07.14.
//  Copyright (c) 2014 tihmstar. All rights reserved.
//

#import "ViewController.h"
#import "freePW_tc7200Eploit.h"
@interface ViewController ()

@end

@implementation ViewController

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}

- (void)viewDidLoad
{
    [self.exploit addTarget:self action:@selector(runExploit:) forControlEvents:UIControlEventTouchUpInside];
    [self.findGateway addTarget:self action:@selector(getGatewayIp:) forControlEvents:UIControlEventTouchUpInside];
    self.loginLable.text = @"";
    self.passLable.text = @"";
    [[self ipfield] setReturnKeyType:UIReturnKeyDone];
    [self.ipfield addTarget:self
                       action:@selector(textFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)getGatewayIp:(id)sender{
    self.ipfield.text = [freePW_tc7200Eploit getIPAddressGateway];
}

-(IBAction)runExploit:(id)sender{
    [[self ipfield] resignFirstResponder];
    NSString *ip = self.ipfield.text;
    
    if ([ip length] > 5) {
        NSArray *cred = [freePW_tc7200Eploit getLoginData:ip];
        if (!cred) {
            NSLog(@"exploit failed");
            self.loginLable.text = @"exploit failed";
            self.passLable.text = @"exploit failed";
            self.loginLable.textColor = [UIColor orangeColor];
            self.passLable.textColor = [UIColor orangeColor];
        }else{
            [self loginLable].text = [cred objectAtIndex:0];
            [self passLable].text = [cred objectAtIndex:1];
            self.loginLable.textColor = [UIColor greenColor];
            self.passLable.textColor = [UIColor greenColor];
        }
    }else{
        self.loginLable.text = @"Error";
        self.passLable.text = @"Error";
        self.loginLable.textColor = [UIColor redColor];
        self.passLable.textColor = [UIColor redColor];
    }
}

@end
