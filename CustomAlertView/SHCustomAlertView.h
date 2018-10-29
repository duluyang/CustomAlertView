
#import <UIKit/UIKit.h>
#import "SHCustomAlertView.h"

typedef NS_ENUM(NSInteger, EAlertAnimationType) {
    Alert_Animate_FadeOut,
    Alert_Animate_Up,
    Alert_Animate_Down,
    Alert_Animate_Scale,
    Alert_Animate_None,
};

typedef NS_ENUM(NSInteger,CustomAlertView_ShowPriority) {
    
    CustomAlertView_ShowType_Common,
    CustomAlertView_ShowType_KickOut,
    CustomAlertView_ShowType_ForceUpdade,
    
};


@class SHCustomAlertView;
@protocol SHCustomAlertViewDelegate <NSObject>

- (void)customAlertView:(SHCustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


@interface SHCustomAlertView : UIView

/**
 *  动画时间段...
 */
@property (nonatomic, assign) NSTimeInterval duration;

/**
 *  是否 弹出控件时 是否 删除 keywindows 上的其他控件。
 */
@property (nonatomic, assign) BOOL isClearKeyWindow;

/**
 *  是否 点击背景 就消失。     默认不消失: NO
 */
@property (nonatomic, assign) BOOL isTouchDismiss;


/**
 是否显示半透明背景
 */
@property (nonatomic, assign) BOOL isShowBgColor;

//标题字体+颜色
@property (nonatomic, strong) UILabel    *mTitleLabel;

/**
 *  左侧按钮 属性
 */
@property (nonatomic, strong) UIButton   *mLeftButton;

/**
 *  右侧按钮 属性
 */
@property (nonatomic, strong) UIButton   *mRightButton;

//消息信息 字体+颜色
@property (nonatomic, strong) UIColor *messageColor;
@property (nonatomic, strong) UIFont *messageFont;

@property (nonatomic, strong, readonly) UIView *mContentView;
@property (nonatomic, strong, readonly) UIView *mLine;

/**
 *  动画效果  默认：Alert_Animate_FadeOut
 */
@property (nonatomic, assign) EAlertAnimationType animationType;

/**
 *  弹框类型  强制升级不允许其他框弹出，退出登录弹框需diss之前的弹框
 */
@property (nonatomic, assign) CustomAlertView_ShowPriority showType;

/**
 单独一个按钮是 按钮宽度是否 保持和两个按钮时一致，默认保持一致。  yes：保持一致  no：按钮宽度变长。
 */
@property (nonatomic, assign) BOOL isKeepButtonWidth;

@property (nonatomic, copy) void (^willShowAlertView)(void);
@property (nonatomic, copy) void (^willDismissAlertView)(void);



//@property (nonatomic, strong, readonly) SHAlertDataItem *curDataItem;


/**
 设置展示信息添加属性显示。
 
 @param sttributedMessage 属性字符串更新。
 */
- (void)setAttributedMessage:(NSAttributedString *)sttributedMessage;


/**
 *  单按钮提示框  默认支持block回调
 */
- (id)initWithTitle:(NSString*)title message:(NSString*)message  onlyButton:(NSString*)buttonTitle;
- (id)initWithTitle:(NSString*)title message:(NSString*)message  leftButton:(NSString*)leftTitle rightButton:(NSString*)rightTitle;


//- (id)initWithAlertDataItem:(SHAlertDataItem*)item;


/**
 *  显示弹出框 回调方式
 */
- (void)showWithCompletionIndexAndTitle:(void (^)(NSInteger selectIndex, NSString*title))completeBlock;
- (void)showWithCompletion:(void (^)(NSInteger selectIndex))completeBlock;


/**
 *   提示框   delegate 方式, 响应点击事件。
 */
- (id)initWithTitle:(NSString*)title message:(NSString*)message  onlyButton:(NSString*)buttonTitle withDelegate:(nullable id)delegate;
- (id)initWithTitle:(NSString*)title message:(NSString*)message  leftButton:(NSString*)leftTitle rightButton:(NSString*)rightTitle withDelegate:(id)delegate;

//显示弹出框  使用 delegate 方式进行处理。
- (void)show;

// 方便子类扩展，一般子类调用，在中间做些其它事情(比如扩展其它UI)
- (void)showWithActionBlock:(void (^)(void))actionBlock;

//手动
- (void)disMiss;

@end


