//
//  ViewController.m
//  UIImageCache
//
//  Created by blackmatch on 2017/2/20.
//  Copyright © 2017年 blackmatch. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "ImageViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic)NSMutableArray *imgs;
@property (assign, nonatomic)NSInteger currentImgIndex;
@property (strong, nonatomic)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *beginBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (copy, nonatomic)NSString *type;
@property (assign, nonatomic)NSInteger currentPage;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation ViewController

- (NSMutableArray *)imgs {
    if (!_imgs) {
        _imgs = [NSMutableArray array];
    }
    
    return _imgs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.currentImgIndex = 0;
    self.currentPage = 0;
    self.type = @"all";
    
    [self startPlayImgs];
}

- (void)getImgs {
    NSDictionary *params = @{@"page":[NSNumber numberWithInteger:self.currentPage]};
    
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.blackmatch.top:3500/image/%@", self.type];
    
    [manage GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *getImgs = (NSArray *)responseObject;
            
            for (NSInteger i = 0; i < getImgs.count; i++) {
                [self.imgs addObject:[getImgs objectAtIndex:i]];
            }
            
        } else {
            NSLog(@"data is not an array");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get urls failed");
        NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextImg {
    if (self.currentImgIndex < self.imgs.count) {
        NSDictionary *imgInfo = [self.imgs objectAtIndex:self.currentImgIndex];
        NSURL *url = [NSURL URLWithString:[imgInfo objectForKey:@"imgUrl"]];
        NSData *imgData = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:imgData];
        
        self.imgView.image = img;
        self.currentImgIndex ++;
        self.countLabel.text = [NSString stringWithFormat:@"当前是第 %ld 张图片", self.currentImgIndex];
        
    } else {
        self.currentPage ++;
        [self getImgs];
    }
}

- (IBAction)changeType:(UISegmentedControl *)sender {
    NSString *type = nil;
    switch (sender.selectedSegmentIndex) {
        case 0:
            type = @"all";
            break;
        case 1:
            type = @"daxiong";
            break;
        case 2:
            type = @"qiaotun";
            break;
        case 3:
            type = @"heisi";
            break;
        case 4:
            type = @"meitui";
            break;
        case 5:
            type = @"yanzhi";
            break;
        case 6:
            type = @"dazahui";
            break;
        default:
            type = @"all";
            break;
    }
    self.type = type;
    self.currentPage = 0;
    self.currentImgIndex = 0;
    [self stopPlayImgs];
    [self.imgs removeAllObjects];
    [self startPlayImgs];
}

- (void)startPlayImgs {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self nextImg];
        }];
        
        self.beginBtn.userInteractionEnabled = NO;
        self.stopBtn.userInteractionEnabled = YES;
    }
}

- (void)stopPlayImgs {
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    
    self.timer = nil;
    self.beginBtn.userInteractionEnabled = YES;
    self.stopBtn.userInteractionEnabled = NO;
}

- (IBAction)begin:(id)sender {
    [self startPlayImgs];
}

- (IBAction)stop:(id)sender {
    [self stopPlayImgs];
}

- (IBAction)showBigImage:(UITapGestureRecognizer *)sender {

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ImageViewController *imageVC = [sb instantiateViewControllerWithIdentifier:@"ImageViewController"];
    imageVC.image = self.imgView.image;
    [self.navigationController pushViewController:imageVC animated:YES];
}


@end
