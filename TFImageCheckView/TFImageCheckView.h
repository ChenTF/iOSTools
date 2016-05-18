//
//  TFImageCheckView.h
//  DoctorYL
//
//  Created by chenTengfei on 15/3/23.
//  Copyright (c) 2015年 yuntai. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 单个图片查看器

/**
 *  单个图片查看器
 */
@interface TFImageCheckView : UIView<UIScrollViewDelegate>

+ (TFImageCheckView *)sharedInstance;


/**
 *  查看图片
 *
 *  @param avatarImageView 图片
 */
- (void)tf_showImageView:(UIImageView*)avatarImageView;

/**
 *  查看图片, 可以给大图
 *
 *  @param avatarImageView 原图片
 *  @param imageNew        新图片(为nil则取原图片)
 */
- (void)tf_showImageView:(UIImageView*)avatarImageView
                   Image:(UIImage *)imageNew;

/**
 *  查看图片, 可以在底部设置文本(类似微信底部介绍)
 *
 *  @param avatarImageView 原图片
 *  @param imageNew        新图片
 *  @param title           标题(如果没有标题,可设置nil)
 *  @param detailTitle     详情
 */
- (void)tf_showImageView:(UIImageView*)avatarImageView
                   Image:(UIImage *)imageNew
                   Title:(NSString *)title
             DetailTitle:(NSString *)detailTitle;






@end
