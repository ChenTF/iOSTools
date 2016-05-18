//
//  TFImageCheckView.m
//  DoctorYL
//
//  Created by chenTengfei on 15/3/23.
//  Copyright (c) 2015年 yuntai. All rights reserved.
//

#import "TFImageCheckView.h"

static UIImageView *orginImageView;

@interface TFImageCheckView ()<UIScrollViewDelegate>

/// 文字背景
@property (nonatomic, strong) UIView *titleView;
/// 文字标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 文字详情
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIScrollView *backGroundScrollView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation TFImageCheckView

static TFImageCheckView *sharedInstance = nil;
#pragma mark Singleton Model
+ (TFImageCheckView *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TFImageCheckView alloc]init];
        
        
        sharedInstance.backGroundScrollView = [[UIScrollView alloc] init];
        sharedInstance.backGroundScrollView.backgroundColor = [UIColor blackColor];
        sharedInstance.backGroundScrollView.maximumZoomScale = 2.0;
        sharedInstance.backGroundScrollView.minimumZoomScale = 1.0;
        sharedInstance.backGroundScrollView.userInteractionEnabled = YES;
        sharedInstance.backGroundScrollView.delegate = sharedInstance;

        sharedInstance.imageView = [[UIImageView alloc] init];
        
        // -- 文字设置
        sharedInstance.titleView = [[UIView alloc] init];
        sharedInstance.titleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        
        sharedInstance.titleLabel = [[UILabel alloc] init];
        sharedInstance.titleLabel.textColor = [UIColor whiteColor];
        
        sharedInstance.detailLabel = [[UILabel alloc] init];
        sharedInstance.detailLabel.textColor = [UIColor whiteColor];
        sharedInstance.detailLabel.numberOfLines = 0;
        
        
    });
    return sharedInstance;
}

#pragma mark - 公共方法
- (void)tf_showImageView:(UIImageView*)avatarImageView {
    [self tf_showImageView:avatarImageView Image:nil];
}

- (void)tf_showImageView:(UIImageView*)avatarImageView
                   Image:(UIImage *)imageNew {
    [self tf_showImageView:avatarImageView Image:imageNew ImageURL:nil Title:nil DetailTitle:nil];
}

- (void)tf_showImageView:(UIImageView*)avatarImageView
                   Image:(UIImage *)imageNew
                   Title:(NSString *)title
             DetailTitle:(NSString *)detailTitle {
    [self tf_showImageView:avatarImageView Image:imageNew ImageURL:nil Title:title DetailTitle:detailTitle];
}


- (void)tf_showImageView:(UIImageView*)avatarImageView
                ImageURL:(NSURL *)imageURL {
    [self tf_showImageView:avatarImageView Image:nil ImageURL:imageURL Title:nil DetailTitle:nil];
}

- (void)tf_showImageView:(UIImageView*)avatarImageView
                ImageURL:(NSURL *)imageURL
                   Title:(NSString *)title
             DetailTitle:(NSString *)detailTitle {
    [self tf_showImageView:avatarImageView Image:nil ImageURL:imageURL Title:title DetailTitle:detailTitle];
}


#pragma mark - 私有方法
- (void)tf_showImageView:(UIImageView*)avatarImageView
                   Image:(UIImage *)imageNew
                ImageURL:(NSURL *)imageURL
                   Title:(NSString *)title
             DetailTitle:(NSString *)detailTitle
{
    orginImageView = avatarImageView;
    orginImageView.alpha = 0;

    
    UIImage *showImage;
    if (imageNew != nil) {
        showImage = imageNew;
    } else if (avatarImageView.image != nil){
        showImage = avatarImageView.image;
    } else {
        return;
    }
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // UIScrollView
    self.backGroundScrollView.frame = window.bounds;
    self.backGroundScrollView.alpha = 0;
    [window addSubview:self.backGroundScrollView];
    
    // UIImageView
    CGRect oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    self.imageView.frame = oldframe;
    self.imageView.image = showImage;
    self.imageView.tag = 1;
    [self.backGroundScrollView addSubview:self.imageView];
    
    // titleView
    if (detailTitle == nil) {
        self.titleView.hidden = YES;
    } else {
        CGFloat distanceWidth = 8;
        CGFloat detailX = distanceWidth;
        
        // titleLabel
        if (title == nil) {
            self.titleLabel.hidden = YES;
        } else {
            self.titleLabel.hidden = NO;
            CGSize titleSize = [title sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(0, 20)];
            self.titleLabel.frame = CGRectMake(distanceWidth, distanceWidth, titleSize.width, titleSize.height);
            self.titleLabel.text = title;
        }
        
        // detailLabel
        detailX = self.titleLabel.width + distanceWidth * 2;
        CGSize detailSize = [detailTitle sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(kScreenBoundWidth - detailX - distanceWidth, 0)];
        self.detailLabel.frame = CGRectMake(detailX, distanceWidth, detailSize.width, detailSize.height);
        self.detailLabel.text = detailTitle;
        
        self.titleView.alpha = 1;
        self.titleView.frame = CGRectMake(0, kScreenBoundHeight - detailSize.height - distanceWidth * 2,
                                          kScreenBoundWidth, detailSize.height + distanceWidth * 2);
        [self.titleView addSubview:self.titleLabel];
        [self.titleView addSubview:self.detailLabel];
        [window addSubview:self.titleView];
        
        
    }

    CGRect imageViewRect;
    if (imageURL == nil) {
        CGFloat WHRatio = self.imageView.image.size.width / self.imageView.image.size.height;
        imageViewRect= CGRectMake(0,
                                          (kScreenBoundHeight - (kScreenBoundWidth / WHRatio)) / 2
                                          ,
                                          kScreenBoundWidth,
                                          kScreenBoundWidth / WHRatio);
    } else {
        // url 格式
        CGFloat WHRatio = self.imageView.image.size.width / self.imageView.image.size.height;
        self.imageView.frame = CGRectMake(0,
                                          (kScreenBoundHeight - (kScreenBoundWidth / WHRatio)) / 2
                                          ,
                                          kScreenBoundWidth,
                                          kScreenBoundWidth / WHRatio);
        
        
    }
    
    // 显示
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.frame = imageViewRect;
        self.backGroundScrollView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
    
    
    // --- 点击事件
    // 双击放大视图
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomInScrollview:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.backGroundScrollView addGestureRecognizer:doubleTap];
    
    // 单击关闭视图
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [self.backGroundScrollView addGestureRecognizer: singleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    
}

/**
 *  隐藏ImageView
 *
 *  @param tap 单击手势
 */
- (void)hideImage:(UITapGestureRecognizer*)singleTapGestureRecognizer{
    
    UIScrollView *backGroundScrollView = (UIScrollView *)singleTapGestureRecognizer.view;
    UIImageView *imageView = (UIImageView*)[backGroundScrollView viewWithTag:1];
    
    [UIView animateWithDuration:0.3 animations:^{
        [backGroundScrollView setZoomScale:1.0 animated:YES];
        imageView.frame = [orginImageView convertRect:orginImageView.bounds toView:[UIApplication sharedApplication].keyWindow];
        backGroundScrollView.alpha = 0;
        self.titleView.alpha = 0;
        orginImageView.alpha = 1;
    } completion:^(BOOL finished) {
        [backGroundScrollView removeFromSuperview];
        [self.titleView removeFromSuperview];
    }];
}

/**
 *  放大ImageView
 *
 *  @param tapGestureRecognizer 双击手势
 */
- (void)zoomInScrollview:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    UIScrollView *backGroundScrollView = (UIScrollView *)tapGestureRecognizer.view;

    if(backGroundScrollView.zoomScale == 2.0) {
        [backGroundScrollView setZoomScale:1.0 animated:YES];
        
        // 调整imageView的位置
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat WHRatio = self.imageView.image.size.width / self.imageView.image.size.height;
            self.imageView.frame = CGRectMake(0,
                                              (kScreenBoundHeight - (kScreenBoundWidth / WHRatio)) / 2
                                              ,
                                              kScreenBoundWidth,
                                              kScreenBoundWidth / WHRatio);
        }];
        
        
        

    } else {
        [backGroundScrollView setZoomScale:2.0 animated:YES];
        
        // 调整imageView的位置
        [UIView animateWithDuration:0.3 animations:^{
            UIImageView *imageView = (UIImageView*)[backGroundScrollView viewWithTag:1];
            imageView.center = CGPointMake(imageView.center.x, backGroundScrollView.contentSize.height / 2);
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return (UIImageView*)[scrollView viewWithTag:1];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}
@end
