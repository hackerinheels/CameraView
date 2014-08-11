//
//  GAViewController.m
//  CameraView
//
//  Created by Garima Agarwal on 8/11/14.
//  Copyright (c) 2014 Garima Agarwal. All rights reserved.
//

#import "GAViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface GAViewController ()

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

-(void)prepareForCameraDisplay;

@end

@implementation GAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.captureSession)
    {
        [self prepareForCameraDisplay];
        CGRect layerRect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        [[self previewLayer] setBounds:layerRect];
        [[self previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
    }
    [[self.view layer] insertSublayer:[self previewLayer] atIndex:0];
    [self.captureSession startRunning];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Capture Session Configuration

-(void)prepareForCameraDisplay
{
    // Initialize the camera - set preview layer, add Back camera video input, and still image output
    [self setCaptureSession:[[AVCaptureSession alloc] init]];
    [self addVideoPreviewLayer];
    [self addVideoInputBackCamera];
    [self addStillImageOutput];
    [self setSessionPreset];
}

- (void)addVideoPreviewLayer
{
	[self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]]];
	[[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

- (void)addVideoInputBackCamera
{
    AVCaptureDevice *newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
    NSError *error = nil;
    AVCaptureDeviceInput *backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:&error];
    if (!error) {
        if ([[self captureSession] canAddInput:backFacingCameraDeviceInput]) {
            [[self captureSession] addInput:backFacingCameraDeviceInput];
        } else {
            NSLog(@"Couldn't add back facing video input");
        }
    }
}

- (void)addStillImageOutput
{
    [self setStillImageOutput:[[AVCaptureStillImageOutput alloc] init]];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [[self stillImageOutput] setOutputSettings:outputSettings];
    [[self captureSession] addOutput:[self stillImageOutput]];
}

-(void)setSessionPreset
{
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        [self.captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
    } else {
        [self.captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    }
}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}



@end
