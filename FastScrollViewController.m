//
//  FastScrollViewController.m
//  Side Effects
//
//  Created by dev on 5/9/13.
//  Copyright (c) 2013 Fluux Development. All rights reserved.
//

#import "FastScrollViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FastScrollViewController ()

@property (nonatomic, strong) NSTimer *fastScrollTimer;
@property BOOL draggingFastScroll;
@property (nonatomic, strong) UITableView *tbl;

@end

@implementation FastScrollViewController
@synthesize fastScrollTimer = _fastScrollTimer;
@synthesize draggingFastScroll = _draggingFastScroll;
@synthesize tbl = _tbl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _draggingFastScroll = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerFastScrollTableView:(UITableView *)tableView {
    _tbl = tableView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self destroyTimer];
    [self showFastScrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_draggingFastScroll) {
        [self setVerticalPositionOfFastScroll:[_tbl rectForRowAtIndexPath:[[_tbl indexPathsForVisibleRows] objectAtIndex:0]].origin.y/_tbl.contentSize.height*self.view.frame.size.height];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self destroyTimer];
    [self fireTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self destroyTimer];
        [self fireTimer];
    }
}

#pragma mark - FastScroll

- (void)setVerticalPositionOfFastScroll:(float)y {
    CGRect frame = _fastScrollView.frame;
    frame.origin.y = y;
    if (frame.origin.y < 0) {
        frame.origin.y = 0;
    } else if (frame.origin.y > self.view.frame.size.height - 35) {
        frame.origin.y = self.view.frame.size.height - 35;
    }
    [_fastScrollView setFrame:frame];
}

- (void)fireTimer {
    _fastScrollTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideFastScrollView) userInfo:nil repeats:NO];
}

- (void)destroyTimer {
    if (_fastScrollTimer) {
        [_fastScrollTimer invalidate];
    }
}

- (void)turnOnFastScroll {
    [self initFastScrollView];
    [self showFastScrollView];
    [self fireTimer];
}

- (void)turnOffFastScroll {
    [_fastScrollView removeFromSuperview];
    _fastScrollView = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self destroyTimer];
    _draggingFastScroll = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self fireTimer];
    _draggingFastScroll = NO;
}

- (void)initFastScrollView {
    _fastScrollView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, 100, 35)];
    [_fastScrollView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f]];
    _fastScrollView.layer.cornerRadius = 10;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapDown:)];
    [pan setMaximumNumberOfTouches:1];
    [_fastScrollView addGestureRecognizer:pan];
    UIImageView *fastImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ButtonMenu@2x"]];
    [fastImg setFrame:CGRectMake(10, 7, 30, 20)];
    [_fastScrollView addSubview:fastImg];
    [self.view addSubview:_fastScrollView];
}

- (void)tapDown:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self.view];
    [self setVerticalPositionOfFastScroll:point.y-17];
    
    float y = 0;
    if ((_fastScrollView.frame.origin.y + _fastScrollView.frame.size.height) > self.view.frame.size.height/2) {
        //if we are below halfway through the table, base everything off of the bottom of the fast scroll view
        y = _tbl.contentSize.height*((_fastScrollView.frame.origin.y+_fastScrollView.frame.size.height)/self.view.frame.size.height);
    } else {
        //otherwise base it on the top of the fast scroll view
        y = _tbl.contentSize.height*(_fastScrollView.frame.origin.y/self.view.frame.size.height);
    }
    if (_fastScrollView.frame.origin.y == self.view.frame.size.height-35) {
        y = _tbl.contentSize.height-44;
    }
    [_tbl scrollRectToVisible:CGRectMake(0, y, _tbl.frame.size.width, 200) animated:NO];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        _draggingFastScroll = NO;
        [self fireTimer];
    }
}

- (void)showFastScrollView {
    if (_fastScrollView.frame.origin.x == self.view.frame.size.width) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _fastScrollView.frame;
            frame.origin.x = self.view.frame.size.width - 50;
            [_fastScrollView setFrame:frame];
        }];
    }
}

- (void)hideFastScrollView {
    if (_fastScrollView.frame.origin.x != self.view.frame.size.width && !_draggingFastScroll) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _fastScrollView.frame;
            frame.origin.x = self.view.frame.size.width;
            [_fastScrollView setFrame:frame];
        }];
    }
}

@end
