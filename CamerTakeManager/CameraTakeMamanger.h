//
//  CameraTakeMamanger.h
//  yilingdoctorCRM
//
//  Created by 陈腾飞 on 14/10/31.
//  Copyright (c) 2014年 yuntai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraTakeMamanger : NSObject

+ (CameraTakeMamanger *)sharedInstance;

#pragma mark - 照片

/**
 *  @brief  从UIActionSheet中选择
 *
 *  @param vc          <#vc description#>
 *  @param block       成功回调
 *  @param cancelBlock 取消回调
 */
- (void)cameraSheetInController:(UIViewController *)vc
                        handler:(void (^)(UIImage *image ,NSString * imagePath))block
                  cancelHandler:(void (^)(void))cancelBlock;


/**
 *  @brief  选择照相机拍照
 *
 *  @param vc          <#vc description#>
 *  @param block       成功回调
 *  @param cancelBlock 取消回调
 */
- (void)imageWithCameraInController:(UIViewController *)vc
                            handler:(void (^)(UIImage *image ,NSString * imagePath))block
                      cancelHandler:(void (^)(void))cancelBlock;

/**
 *  @brief  从相册选择
 *
 *  @param vc          <#vc description#>
 *  @param block       成功回调
 *  @param cancelBlock 取消回调
 */
- (void)imageWithPhotoInController:(UIViewController *)vc
                           handler:(void (^)(UIImage *image ,NSString * imagePath))block
                     cancelHandler:(void (^)(void))cancelBlock;

@end
