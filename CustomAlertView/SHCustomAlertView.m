
#import "SHCustomAlertView.h"
//#import "UILabel+Additions.h"
//#import "SHUIModuleDefine.h"
//#import "UIColor+ColorConvert.h"

@interface SHCustomAlertView ()
@property (nonatomic, strong) UIView     *mBgView;

@property (nonatomic, strong) UIView     *mContentView;
@property (nonatomic, strong) UIView     *mLine;
@property (nonatomic, strong) UILabel    *mMessageLabel;


//数据源
@property (nonatomic, copy) NSString *mTitle;
@property (nonatomic, copy) NSString *mMessage;
@property (nonatomic, copy) NSAttributedString *mMessageAttributedString;
@property (nonatomic, copy) NSString *mLeftButtonTitle;
@property (nonatomic, copy) NSString *mRightButtonTitle;

@property (nonatomic, copy) void (^didSelcectButtonAtIndex)(NSInteger index);
@property (nonatomic, copy) void (^didSelcectButtonAtIndexWithTitle)(NSInteger index, NSString *buttonText);

@property (nonatomic, weak) id<SHCustomAlertViewDelegate> m_delegate;

@property (nonatomic, assign) CGFloat gapWidth;
@property (nonatomic, assign) CGFloat  alpha;

//@property (nonatomic, strong) SHAlertDataItem *curDataItem;
@end

@implementation SHCustomAlertView

- (id)initWithTitle:(NSString*)title message:(NSString*)message  onlyButton:(NSString*)buttonTitle{
    return [self initWithTitle:title message:message onlyButton:buttonTitle withDelegate:nil];
}

- (id)initWithTitle:(NSString*)title message:(NSString*)message  onlyButton:(NSString*)buttonTitle withDelegate:(nullable id)delegate{
    return [self initWithTitle:title message:message leftButton:buttonTitle rightButton:nil withDelegate:delegate];
}

- (id)initWithTitle:(NSString*)title message:(NSString*)message  leftButton:(NSString*)leftTitle rightButton:(NSString*)rightTitle{
    return [self initWithTitle:title message:message leftButton:leftTitle rightButton:rightTitle withDelegate:nil];
}


//- (id)initWithAlertDataItem:(SHAlertDataItem *)item{
//    self.curDataItem = item;
//    return [self initWithTitle:item.title message:item.message leftButton:item.leftBtnTitle rightButton:item.rightBtnTitle];
//}

- (id)initWithTitle:(NSString*)title message:(NSString*)message  leftButton:(NSString*)leftTitle rightButton:(NSString*)rightTitle withDelegate:(id)delegate{
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)]) {
        
        self.m_delegate = delegate;
        self.mTitle = title;
        self.mMessage = message;
        self.mLeftButtonTitle = leftTitle;
        self.mRightButtonTitle = rightTitle;
        
        self.gapWidth = 20;
        self.duration = 0.35f;
        self.alpha = 0.4f;
        self.isTouchDismiss = NO;
        self.animationType = Alert_Animate_FadeOut;//
        self.isKeepButtonWidth = YES;
        
        //消息体。
        //self.messageFont = kPingfangRegularFont(18);
        //self.messageColor = kDefaultBlackColor;
    }
    return self;
}

- (void)setAttributedMessage:(NSAttributedString *)sttributedMessage{
    self.mMessageAttributedString = sttributedMessage;
    //    [self.mMessageLabel setAttributedText:sttributedMessage];
}

- (void)setupUI{
    //大背景
    [self addSubview:self.mBgView];
    
    //内容背景
    [self addSubview:self.mContentView];
    
    //标题
    [self.mContentView addSubview:self.mTitleLabel];
    
    //分割线
    [self.mContentView addSubview:self.mLine];
    
    //消息。
    [self.mContentView addSubview:self.mMessageLabel];
    [self.mMessageLabel setText:self.mMessage];
    if (self.mMessageAttributedString.length > 0 ) {
        [self.mMessageLabel setAttributedText:self.mMessageAttributedString];
    }
    //[self.mMessageLabel adjustLabelHeight];
    
    
    [self.mContentView addSubview:self.mLeftButton];
    [self.mContentView addSubview:self.mRightButton];
    
    //两个按钮。
    CGFloat buttonWidht = (CGRectGetWidth(self.mContentView.frame) -  self.gapWidth*3)/2;
    if (self.mLeftButtonTitle.length >0 && self.mRightButtonTitle.length > 0) {
        self.mLeftButton.hidden = self.mRightButton.hidden = NO;
        self.mLeftButton.tag = 0;
        self.mRightButton.tag = 1;
        
        [self.mLeftButton setTitle:self.mLeftButtonTitle forState:UIControlStateNormal];
        [self.mRightButton setTitle:self.mRightButtonTitle forState:UIControlStateNormal];
        
        [self.mLeftButton setFrame:CGRectMake(self.gapWidth, CGRectGetMaxY(self.mMessageLabel.frame) + self.gapWidth, buttonWidht, 42)];
        [self.mRightButton setFrame:CGRectMake(CGRectGetMaxX(self.mLeftButton.frame)+ self.gapWidth, CGRectGetMinY(self.mLeftButton.frame), CGRectGetWidth(self.mLeftButton.frame), CGRectGetHeight(self.mLeftButton.frame))];
        
        CGRect frame = self.mContentView.frame;
        frame.size.height = CGRectGetMaxY(self.mRightButton.frame) + 18;
        self.mContentView.frame = frame;
    }
    else{
        //
        NSString* titleText = NSLocalizedString(@"Confirm", @"确定");
        if (self.mLeftButtonTitle.length > 0) {
            titleText = self.mLeftButtonTitle;
        }
        else{
            if (self.mRightButtonTitle.length > 0) {
                titleText = self.mRightButtonTitle;
            }
        }
        [self.mRightButton setTitle:titleText forState:UIControlStateNormal];
        
        self.mLeftButton.hidden = YES;
        self.mRightButton.hidden = NO;
        self.mRightButton.tag = 0;
        
        if (!_isKeepButtonWidth) {
            buttonWidht = (CGRectGetWidth(self.mContentView.frame) -  self.gapWidth*2);
        }
        [self.mRightButton setFrame:CGRectMake(CGRectGetWidth(self.mContentView.frame) /2 -  buttonWidht/2, CGRectGetMaxY(self.mMessageLabel.frame) + self.gapWidth, buttonWidht, 42)];
        
        CGRect frame = self.mContentView.frame;
        frame.size.height = CGRectGetMaxY(self.mRightButton.frame) + 18;
        self.mContentView.frame = frame;
    }
    
}


#pragma mark -  p

- (void)setMessageColor:(UIColor *)messageColor{
    _messageColor = messageColor;
    [self.mMessageLabel setTextColor:messageColor];
}

- (void)setMessageFont:(UIFont *)messageFont{
    _messageFont = messageFont;
    //    [self setupUI];
}

- (void)setIsShowBgColor:(BOOL)isShowBgColor{
    _isShowBgColor = isShowBgColor;
    if (isShowBgColor) {
        self.mBgView.backgroundColor  = [UIColor blackColor];
    }
    else{
        self.mBgView.backgroundColor  = [UIColor clearColor];
    }
}

- (void)setIsClearKeyWindow:(BOOL)isClearKeyWindow{
    _isClearKeyWindow = isClearKeyWindow;
    if (isClearKeyWindow) {
        for (NSInteger i = [UIApplication sharedApplication].delegate.window.subviews.count -  1; i >= 0; i-- ) {
            UIView *tempView = [UIApplication sharedApplication].delegate.window.subviews[i];
            if ([tempView isKindOfClass:[SHCustomAlertView class]]) {
                [tempView removeFromSuperview];
            }
        }
    }
}

#pragma mark -
- (void)buttonAction:(UIButton*)sender{
    if (self.didSelcectButtonAtIndexWithTitle) {
        self.didSelcectButtonAtIndexWithTitle(sender.tag, sender.titleLabel.text);
    }
    else if (self.didSelcectButtonAtIndex){
        self.didSelcectButtonAtIndex(sender.tag);
    }
    else{
        //支持委托方式
        if (_m_delegate && [_m_delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)]) {
            [_m_delegate customAlertView:self clickedButtonAtIndex:sender.tag];
        }
    }
    
    //页面小时
    if (self.willDismissAlertView) {
        self.willDismissAlertView();
    }
    [self disMiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (_isTouchDismiss) {
        [self disMiss];
        if (self.willDismissAlertView) {
            self.willDismissAlertView();
        }
    }
}

- (void)showWithCompletionIndexAndTitle:(void (^)(NSInteger, NSString *))completeBlock{
    [self show];
    [self setDidSelcectButtonAtIndexWithTitle:completeBlock];
}

- (void)showWithCompletion:(void (^)(NSInteger))completeBlock{
    [self show];
    [self setDidSelcectButtonAtIndex:completeBlock];
}

- (void)showWithActionBlock:(void (^)(void))actionBlock{
    [self setupUI];
    if (actionBlock) {
        actionBlock();
    }
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    if (self.willShowAlertView) {
        self.willShowAlertView();
    }
    
    CGFloat  centerY_Scale = 0.45f;
    
    self.mBgView.alpha = 0.0f;
    switch (self.animationType) {
        case Alert_Animate_Down:{
            _mContentView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)+CGRectGetHeight(_mContentView.frame)/2);
            [UIView animateWithDuration:_duration animations:^{
                self.mBgView.alpha = self.alpha;
                self.mContentView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame) * centerY_Scale);
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
        case Alert_Animate_Up:{
            _mContentView.center = CGPointMake(CGRectGetWidth(self.frame)/2, - CGRectGetHeight(_mContentView.frame)/2);
            [UIView animateWithDuration:_duration animations:^{
                self.mBgView.alpha = self.alpha;
                self.mContentView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame) *  centerY_Scale);
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
        case Alert_Animate_FadeOut:{
            _mContentView.alpha = 0.0f;
            _mContentView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame) *  centerY_Scale);
            [UIView animateWithDuration:_duration animations:^{
                self.mBgView.alpha = self.alpha;
                self.mContentView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
        case Alert_Animate_Scale:{
            _mContentView.alpha = 1.0f;
            _mContentView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame) *  centerY_Scale);
            self.mContentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            [UIView animateWithDuration:_duration animations:^{
                self.mBgView.alpha = self.alpha;
                self.mContentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
            
        case Alert_Animate_None:{
            self.mBgView.alpha = self.alpha;
            self.mContentView.alpha =1.0f;
            self.mContentView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame) *  centerY_Scale);
        }
            break;
            
        default:
            break;
    }
}

- (void)show
{
    [self showWithActionBlock:nil];
}

- (void)disMiss{
    switch (self.animationType) {
        case Alert_Animate_Down:{
            [UIView animateWithDuration:_duration animations:^{
                self.mBgView.alpha = 0.0f;
                self.mContentView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)+CGRectGetHeight(self.mContentView.frame)/2);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            
        }
            break;
            
        case Alert_Animate_Up:{
            [UIView animateWithDuration:_duration animations:^{
                self.mBgView.alpha = 0.0f;
                self.mContentView.center = CGPointMake(CGRectGetWidth(self.frame)/2, - CGRectGetHeight(self.mContentView.frame)/2);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            
        }
            break;
            
        case Alert_Animate_FadeOut:{
            _mContentView.alpha = 1.0f;
            [UIView animateWithDuration:_duration animations:^{
                self.mBgView.alpha = 0.0f;
                self.mContentView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            
        }
            break;
            
        case Alert_Animate_Scale:{
            _mContentView.alpha = 1.0f;
            self.mContentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [UIView animateWithDuration:_duration animations:^{
                self.mBgView.alpha = 0.0f;
                self.mContentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
            break;
            
        case Alert_Animate_None:{
            [self removeFromSuperview];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
- (UIView*)mBgView{
    if (!_mBgView) {
        _mBgView = [[UIView alloc] initWithFrame:self.bounds];
        _mBgView.backgroundColor = [UIColor blackColor];
        
    }
    return _mBgView;
}

- (UIView*)mContentView{
    if (!_mContentView) {
        //内容背景
        CGFloat widht  = CGRectGetWidth(self.bounds) -  (self.gapWidth)*2;
        _mContentView = [[UIView alloc] initWithFrame:CGRectMake(self.gapWidth, CGRectGetHeight(self.bounds), widht, 40)];
        _mContentView.backgroundColor = [UIColor whiteColor];
        _mContentView.layer.cornerRadius = 8.f;
        //_mContentView.layer.borderColor = kLightGreyColor.CGColor;
        _mContentView.layer.borderWidth = 0.5F;
        
    }
    return _mContentView;
}

- (UILabel*)mTitleLabel{
    if (!_mTitleLabel) {
        //标题
        _mTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.gapWidth), 15, CGRectGetWidth(self.mContentView.frame) -  (self.gapWidth)*2, 25)];
        [_mTitleLabel setText:self.mTitle];
        //_mTitleLabel.font = kPingfangRegularFont(16);
        //_mTitleLabel.textColor = kDefaultGreyColor;
        _mTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_mTitleLabel setBackgroundColor:[UIColor clearColor]];
    }
    return _mTitleLabel;
}

- (UIView*)mLine{
    if (!_mLine) {
        //分割线
        _mLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mTitleLabel.frame)+ (self.gapWidth)/2, CGRectGetWidth(self.mContentView.frame), 0.5f)];
       // _mLine.backgroundColor = kLightGreyColor;
    }
    return _mLine;
}


- (UILabel*)mMessageLabel{
    if (!_mMessageLabel) {
        //信息
        _mMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.gapWidth), CGRectGetMaxY(self.mLine.frame)+ self.gapWidth, CGRectGetWidth(self.mContentView.frame)-  (self.gapWidth)*2, 100)];
        _mMessageLabel.font = self.messageFont;
        _mMessageLabel.textColor = self.messageColor;
        _mMessageLabel.textAlignment = NSTextAlignmentCenter;
        [_mMessageLabel setBackgroundColor:[UIColor clearColor]];
    }
    return _mMessageLabel;
}

- (UIButton*)mLeftButton{
    if (!_mLeftButton) {
        _mLeftButton = [[UIButton alloc] initWithFrame:CGRectMake(self.gapWidth, CGRectGetMaxY(self.mMessageLabel.frame)+10, 0, 42)];
        _mLeftButton.backgroundColor = [UIColor whiteColor];
        //_mLeftButton.layer.borderColor = kDefaultGreyColor.CGColor;
        _mLeftButton.layer.borderWidth = 0.5F;
        _mLeftButton.layer.cornerRadius = 5.0f;
        
        //[_mLeftButton  setTitleColor:kDefaultGreyColor forState:UIControlStateNormal];
        //_mLeftButton.titleLabel.font = kPingfangRegularFont(18);
        _mLeftButton.tag = 0;
        [_mLeftButton setTitle:self.mLeftButtonTitle forState:UIControlStateNormal];
        [_mLeftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mLeftButton;
}


- (UIButton*)mRightButton{
    if (!_mRightButton) {
        _mRightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.gapWidth, CGRectGetMaxY(self.mMessageLabel.frame)+10, 0, 42)];
        //_mRightButton.backgroundColor = kDefaultButtonColor;
        //_mRightButton.layer.borderColor = SHColorWithHexString(@"#FFFFFF").CGColor;
        _mRightButton.layer.borderWidth = 0.5F;
        _mRightButton.layer.cornerRadius = 5.0f;
        
       // [_mRightButton  setTitleColor:SHColorWithHexString(@"#FFFFFF") forState:UIControlStateNormal];
       // _mRightButton.titleLabel.font = kPingfangRegularFont(18);
        _mRightButton.tag = 1;
        [_mRightButton setTitle:self.mRightButtonTitle forState:UIControlStateNormal];
        [_mRightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mRightButton;
}



@end
