//
//  ViewController.m
//  CSNPageControlDemo
//
//  Created by griffin_stewie on 2014/07/18.
//  Copyright (c) 2014 cyan-stivy.net. All rights reserved.
//

#import "ViewController.h"
#import "CSNPageControl.h"

@interface ViewController ()
@property (nonatomic, strong) CSNPageControl *pageControl;
@property (nonatomic, strong) UIPageControl *uiPageControl;
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:0.898 alpha:1.000];
    self.pageControl = [[CSNPageControl alloc] initWithFrame:CGRectMake(10, 60, 300, 20)];
    self.pageControl.numberOfPages = 3;
    self.pageControl.backgroundColor = [UIColor colorWithRed:0.350 green:0.614 blue:0.664 alpha:1.000];
    [self.view addSubview:self.pageControl];


    self.uiPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, 100, 300, 20)];
    self.uiPageControl.backgroundColor = [UIColor redColor];
    self.uiPageControl.numberOfPages = 3;
    [self.uiPageControl addTarget:self action:@selector(uiPageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.uiPageControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uiPageControlValueChanged:(id)sender
{
    BOOL animated = YES;
    if (animated) {
        [self.pageControl setCurrentPage:self.uiPageControl.currentPage + 1 animated:animated];
    } else {
        self.pageControl.currentPage = self.uiPageControl.currentPage + 1;
    }
}
@end
