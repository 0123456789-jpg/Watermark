//
//  ViewController.h
//  Watermark
//
//  Created by David 🤴 on 2021/10/22.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak,nonatomic) IBOutlet NSButton *picture;
@property (weak,nonatomic) IBOutlet NSButton *watermark;
@property (weak,nonatomic) IBOutlet NSImageView *pictureView;
@property (weak,nonatomic) IBOutlet NSImageView *watermarkView;
@property (weak,nonatomic) IBOutlet NSButton *generate;
@property (weak,nonatomic) IBOutlet NSImageView *resultView;
@property (weak,nonatomic) IBOutlet NSSegmentedControl *renderer;
@property (weak,nonatomic) IBOutlet NSButton *save;

-(CGImageRef)NS2CG:(NSImage*)image;
-(NSImage*)CG2NS:(CGImageRef)CGImage;
@end

