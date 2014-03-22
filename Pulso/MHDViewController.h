//
//  MHDViewController.h
//  Pulso
//
//  Created by Schwietering, Jürgen on 22.03.14.
//  Copyright (c) 2014 Schwietering, Jürgen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface MHDViewController : GLKViewController

@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;


- (IBAction)modelAction:(id)sender;
- (IBAction)closeWebView:(id)sender;


@end
