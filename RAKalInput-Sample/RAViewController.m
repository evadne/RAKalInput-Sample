//
//  RAViewController.m
//  InputViewTest
//
//  Created by Evadne Wu on 10/5/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import "RAKalInput.h"
#import "RAViewController.h"


@interface RAViewController () <RAKalInputViewControllerDelegate>

@property (nonatomic, readonly, strong) UIButton *overlayDismissButton;

@property (nonatomic, readonly, strong) RAKalInputViewController *inputViewController;

@end


@implementation RAViewController
@synthesize inputViewController = _inputViewController;
@synthesize overlayDismissButton = _overlayDismissButton;

- (void) viewDidLoad {
	
	[super viewDidLoad];
	
	self.textField.inputAccessoryView = self.inputViewController.view;
	self.textField.inputView = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, 320, 0}];
	
}

- (void) viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(handleKeyboard:) name:UIKeyboardWillShowNotification object:nil];
	[nc addObserver:self selector:@selector(handleKeyboard:) name:UIKeyboardWillHideNotification object:nil];

}

- (void) viewWillDisappear:(BOOL)animated {

	[super viewWillDisappear:animated];

	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	
}

- (void) handleKeyboard:(NSNotification *)note {

	NSDictionary *userInfo = [note userInfo];
	NSNumber *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	NSTimeInterval duration = [durationValue doubleValue];
	
	NSNumber *curveValue = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	UIViewAnimationCurve curve = [curveValue unsignedIntegerValue];
	
	BOOL hide = [note.name isEqualToString:UIKeyboardWillHideNotification] ? YES :
		[note.name isEqualToString:UIKeyboardWillShowNotification] ? NO :
			NO;
	
	if (![self.textField isFirstResponder])
		hide = YES;
	else if (!hide)
		duration = MAX(duration, 0.15f);
	
	[self setOverlayViewHidden:hide withAnimationDuration:duration curve:curve];

}

- (void) viewWillLayoutSubviews {

	[super viewWillLayoutSubviews];
	[self setOverlayViewHidden:![self.textField isFirstResponder] withAnimationDuration:0.0f curve:UIViewAnimationCurveLinear];
	
}

- (UIButton *) overlayDismissButton {

	if (!_overlayDismissButton) {
	
		_overlayDismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_overlayDismissButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.35f];
		
		[_overlayDismissButton addTarget:self action:@selector(handleOverlayDismissButtonTap:) forControlEvents:UIControlEventTouchUpInside];
		
		[self.view addSubview:_overlayDismissButton];
	
	}
	
	return _overlayDismissButton;

}

- (void) handleOverlayDismissButtonTap:(id)sender {

	[self.textField resignFirstResponder];

}

- (void) setOverlayViewHidden:(BOOL)hidden withAnimationDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve {
	
	UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction | ((UIViewAnimationOptions[]){
		[UIViewAnimationCurveLinear] = UIViewAnimationOptionCurveLinear,
		[UIViewAnimationCurveEaseIn] = UIViewAnimationOptionCurveEaseIn,
		[UIViewAnimationCurveEaseOut] = UIViewAnimationOptionCurveEaseOut,
		[UIViewAnimationCurveEaseInOut] = UIViewAnimationOptionCurveEaseInOut,
	})[curve];
	
	BOOL overlayVisible = !hidden;	//	[self.textField isFirstResponder];
	
	UIButton *odb = self.overlayDismissButton;
	odb.userInteractionEnabled = overlayVisible;
	odb.frame = self.view.bounds;
	
	[UIView animateWithDuration:duration delay:0.0f options:options animations:^{
		
		odb.alpha = overlayVisible ? 1.0f : 0.0f;

	} completion:^(BOOL finished) {
	
		//	?
		
	}];


}

- (RAKalInputViewController *) inputViewController {

	if (!_inputViewController) {

		_inputViewController = [[RAKalInputViewController alloc] initWithNibName:nil bundle:nil];
		_inputViewController.delegate = self;
		
	}
	
	return _inputViewController;
	
}

- (void) kalInputViewController:(RAKalInputViewController *)controller didSelectDate:(NSDate *)date {

	static dispatch_once_t onceToken;
	static NSDateFormatter *dateFormatter;
	dispatch_once(&onceToken, ^{
		dateFormatter = [NSDateFormatter new];
		dateFormatter.dateStyle = NSDateFormatterMediumStyle;
		dateFormatter.timeStyle = NSDateFormatterNoStyle;
	});
	
	self.textField.text = [dateFormatter stringFromDate:date];

}

@end
