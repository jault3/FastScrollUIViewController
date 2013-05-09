//
//  FastScrollViewController.h
//  Side Effects
//
//  Created by dev on 5/9/13.
//  Copyright (c) 2013 Fluux Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FastScrollViewController : UIViewController

@property BOOL fastScroll;
@property UIView *fastScrollView;

- (void)registerFastScrollTableView:(UITableView *)tableView;
- (void)turnOnFastScroll;
- (void)turnOffFastScroll;
- (void)showFastScrollView;
- (void)hideFastScrollView;

@end
