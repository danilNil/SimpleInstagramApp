//
//  ViewController.h
//  SimpleInstagramApp
//
//  Created by Danil on 22.09.12.
//  Copyright (c) 2012 Danil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *drawingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *drawingView;

- (IBAction)share:(id)sender;
- (IBAction)getImage:(id)sender;
@end
