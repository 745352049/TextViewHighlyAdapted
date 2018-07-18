//
//  ViewController.m
//  TextViewHighlyAdapted
//
//  Created by 水晶岛 on 2018/7/4.
//  Copyright © 2018年 水晶岛. All rights reserved.
//

#import "ViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) CGFloat keyH;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesAction)];
    tapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
}
- (void)gesAction {
    [self.textView resignFirstResponder];
}
#pragma mark - 键盘监听方法
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyH = keyboardFrame.size.height;
    [UIView animateWithDuration:duration animations:^{
        if (keyboardFrame.origin.y == SCREEN_HEIGHT) {
            self.textView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 40);
        } else {
            self.textView.frame = CGRectMake(0, SCREEN_HEIGHT - keyboardFrame.size.height - 40, SCREEN_WIDTH, 40);
        }
    }];
}
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger height = ceilf([self.textView sizeThatFits:CGSizeMake(self.textView.bounds.size.width, MAXFLOAT)].height);
    if (height != 40 ) {
        self.textView.scrollEnabled = height > 80;
        if (self.textView.scrollEnabled == NO) {
            [self aaa:height];
        }
    }
}
- (void)aaa:(CGFloat)height {
    self.textView.frame = CGRectMake(0, SCREEN_HEIGHT - self.keyH - height, SCREEN_WIDTH, height);
}
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 40);
        _textView.textColor = [UIColor blackColor];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
        _textView.layer.borderWidth = 1.0f;
        _textView.scrollEnabled = YES;
    }
    return _textView;
}
- (IBAction)buttonAction:(UIButton *)sender {
    [self.view addSubview:self.textView];
    [self.textView becomeFirstResponder];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
