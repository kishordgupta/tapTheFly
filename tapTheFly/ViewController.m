//
//  ViewController.m
//  tapTheFly
//
//  Created by TMMAC02 on 12/25/15.
//  Copyright © 2015 Silicon Orchard Ltd. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestKivaLoansURL [NSURL URLWithString:@"http://www.siliconorchard.com/app/quiz.json"]

@interface ViewController (){
    
    NSArray* elements;
    NSArray* results;
    int randNum;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self DidFinishCheckingInternetConnectivity]) {
        
        dispatch_async(kBgQueue, ^{
            
            NSData* data = [NSData dataWithContentsOfURL:
                            kLatestKivaLoansURL];
            [self performSelectorOnMainThread:@selector(processServerData:)
                                   withObject:data waitUntilDone:YES];
        });
    }
    else{
        [[[UIAlertView alloc]  initWithTitle:@"Alert!" message:@"No internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)processServerData:(NSData *)responseData{
    
    NSError* error;
    NSDictionary* jsonDic = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    elements = [jsonDic valueForKey:@"elements"];
    results = [jsonDic valueForKey:@"result"];
    
    [self setData];
    NSLog(@"response: %@", jsonDic); //3
}

- (void)setData{
    
    randNum = rand() % elements.count;
    
    self.elementLabel.text = [NSString stringWithFormat:@"%@",[elements objectAtIndex:randNum]];
}


- (IBAction)flyAction:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        
        if ([[results objectAtIndex:randNum] integerValue]==1) {
            UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Result?" message:@"Correct" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Next", nil];
            alert.tag = 2001;
            [alert show];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Result?" message:@"Incorrect" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Next", nil];
            alert.tag = 2001;
            [alert show];
            
        }
    }
    else{
        if ([[results objectAtIndex:randNum] integerValue]==0) {
            UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Result?" message:@"Correct" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Next", nil];
            alert.tag = 2001;
            [alert show];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:@"Result?" message:@"Incorrect" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Next", nil];
            alert.tag = 2001;
            [alert show];
            
        }
        
        
    }

}


-(BOOL) DidFinishCheckingInternetConnectivity{
    
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return FALSE;
    } else {
        return TRUE;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2001) {
        if (buttonIndex == 1) {
            [self setData];
            return;
        }
        
    }
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
