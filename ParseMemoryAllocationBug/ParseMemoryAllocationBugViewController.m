//
//  ParseMemoryAllocationBugViewController.m
//  ParseMemoryAllocationBug
//
//  Created by Scott Carter on 2/5/13.
//  Copyright (c) 2013 Scott Carter. All rights reserved.
//

#import "ParseMemoryAllocationBugViewController.h"

@interface ParseMemoryAllocationBugViewController ()

@end

@implementation ParseMemoryAllocationBugViewController

#define NUM_RECORDS_PER_SAVE 30

// How many loops of NUM_RECORDS_PER_SAVE records 
#define NUM_LOOPS_FOR_MULTI_SAVE 3



- (IBAction)singleSaveAll:(UIButton *)sender {
    [self addObjectsToPassForLoopNum:0 withMultipleSave:NO];
    
}


- (IBAction)multipleSaveAll:(UIButton *)sender {
    [self addObjectsToPassForLoopNum:0 withMultipleSave:YES];
}


- (void) addObjectsToPassForLoopNum:(NSUInteger)loopNum
                   withMultipleSave:(BOOL)multipleSave
{
    // Array of objects to save
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    
    // Create a string to save to Parse record
    NSString *mystr = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; // 36 bytes in length
    
    NSString *noteStr = [@"" stringByPaddingToLength:100 * [mystr length] withString:mystr startingAtIndex:0]; // 3,600 bytes in length
    
    
    // Populate the arrary
    for(NSUInteger i = 0; i < NUM_RECORDS_PER_SAVE; i++) {
        
        // Create a PFObject for new entry
        PFObject *pobj = [PFObject objectWithClassName:@"Test"];
        
        [pobj setObject:noteStr forKey:@"note"];
        
        [arr addObject:pobj];
    }
    
    
    // Save all objects at once to Parse
    [PFObject saveAllInBackground:arr block:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            NSLog(@"Save is completed successfully for loopNum %d",loopNum);
            
            // Call ourselves recursively if multipleSave == YES and this is not the last
            // loop.
            if (multipleSave && (loopNum != (NUM_LOOPS_FOR_MULTI_SAVE - 1)) ) {
                [self addObjectsToPassForLoopNum:(loopNum+1) withMultipleSave:YES];
            }
        }
        else {
            NSString *err = [[error userInfo] objectForKey:@"error"];
            
            NSLog(@"Parse save did not succeed.  Error was %@",err);
        }
        
    }];
    
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
	    
    
}



@end
