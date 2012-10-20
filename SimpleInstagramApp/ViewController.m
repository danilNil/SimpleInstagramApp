//
//  ViewController.m
//  SimpleInstagramApp
//
//  Created by Danil on 22.09.12.
//  Copyright (c) 2012 Danil. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property(nonatomic, strong)     UIDocumentInteractionController* docController;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)share:(id)sender {
    
    _drawingImageView.image = _imageView.image;
    _drawingView.hidden=NO;
    UIImage* instaImage = [self thumbnailFromView:_drawingView];
    _drawingView.hidden=YES;
    NSString* imagePath = [NSString stringWithFormat:@"%@/image.igo", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    [UIImagePNGRepresentation(instaImage) writeToFile:imagePath atomically:YES];
    NSLog(@"image size: %@", NSStringFromCGSize(instaImage.size));
    _docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:imagePath]];
    _docController.delegate=self;
    _docController.UTI = @"com.instagram.exclusivegram";
    [_docController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
}

- (IBAction)getImage:(id)sender {
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    _imageView.image = [info valueForKey:UIImagePickerControllerEditedImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(UIImage*)thumbnailFromView:(UIView*)_myView{
	return [self thumbnailFromView:_myView withSize:_myView.frame.size];
}

-(UIImage*)thumbnailFromView:(UIView*)_myView withSize:(CGSize)viewsize{

    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        // Retina display
        CGSize newSize = viewsize;
        newSize.height=newSize.height*2;
        newSize.width=newSize.width*2;
        viewsize=newSize;
    }

    UIGraphicsBeginImageContext(_myView.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, YES);
	[_myView.layer renderInContext: context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();


	CGSize size = _myView.frame.size;
	CGFloat scale = MAX(viewsize.width / size.width, viewsize.height / size.height);
	
	UIGraphicsBeginImageContext(viewsize);
	CGFloat width = size.width * scale;
	CGFloat height = size.height * scale;
	float dwidth = ((viewsize.width - width) / 2.0f);
	float dheight = ((viewsize.height - height) / 2.0f);
	CGRect rect = CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
	[image drawInRect:rect];
	UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newimg;
}


@end
