#import "RNCropper.h"

#import "TOCropViewController.h"

@interface RNCropper () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate>

@end

NSString *const RCT_ERROR_USER_CANCELED = @"RCT_ERROR_USER_CANCELED";
NSString *const RCT_ERROR_UNKNOWN = @"RCT_ERROR_UNKNOWN";
NSString *const RCT_ERROR_PERMISSIONS_MISSING = @"RCT_ERROR_PERMISSIONS_MISSING";

@implementation RNCropper
{
    RCTPromiseResolveBlock _resolver;
    RCTPromiseRejectBlock _rejecter;
    float _width;
    float _height;
}

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (NSDictionary *)constantsToExport
{
    return @{
             @"ERROR_USER_CANCELED": RCT_ERROR_USER_CANCELED,
             @"ERROR_UNKNOWN": RCT_ERROR_UNKNOWN,
             @"ERROR_PERMISSIONS_MISSING": RCT_ERROR_PERMISSIONS_MISSING
             };
}

- (UIViewController*) getRootViewController {
    UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (root.presentedViewController != nil) {
        root = root.presentedViewController;
    }

    return root;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:image];
    cropController.customAspectRatio = CGSizeMake(_width, _height);
    cropController.delegate = self;

    [cropController setAspectRatioPreset:TOCropViewControllerAspectRatioPresetCustom animated: false];
    [cropController setAspectRatioLockEnabled:true];
    [cropController setResetAspectRatioEnabled:false];

    [picker dismissViewControllerAnimated:NO completion:^{
        [[self getRootViewController] presentViewController:cropController animated:YES completion:nil];
    }];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)original withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    if (_resolver != nil) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(_width, _height), NO, 1);
        [original drawInRect:CGRectMake(0, 0, _width, _height)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        NSData *data = UIImageJPEGRepresentation(image, 0.9);
        _resolver([data base64EncodedStringWithOptions:0]);
    }

    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelle
{
    if (_rejecter != nil) {
        NSError *error = nil;
        _rejecter(RCT_ERROR_USER_CANCELED, @"User canceled on cropper", error);
    }

    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (_rejecter == nil) {
        NSError *error = nil;
        _rejecter(RCT_ERROR_USER_CANCELED, @"User canceled on image picker", error);
    }

    [picker dismissViewControllerAnimated:YES completion:nil];
}

RCT_EXPORT_METHOD(getPhotoFromAlbum:(NSDictionary *)params
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    picker.delegate = self;
    
    _width = [RCTConvert float:params[@"width"]];
    _height = [RCTConvert float:params[@"height"]];

    _resolver = resolve;
    _rejecter = reject;

    [[self getRootViewController] presentViewController:picker animated:YES completion:nil];
}

RCT_EXPORT_METHOD(getPhotoFromCamera:(NSDictionary *)params
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = NO;
    picker.delegate = self;
    
    _width = [RCTConvert float:params[@"width"]];
    _height = [RCTConvert float:params[@"height"]];

    _resolver = resolve;
    _rejecter = reject;

    [[self getRootViewController] presentViewController:picker animated:YES completion:nil];
}

@end
