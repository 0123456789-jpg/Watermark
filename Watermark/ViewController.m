//
//  ViewController.m
//  Watermark
//
//  Created by David 🤴 on 2021/10/22.
//

#import "ViewController.h"
#import "Watermark-Swift.h"

NSImage *PICTURE = nil;
NSImage *WATERMARK = nil;
NSImage *RESULT = nil;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    _picture.target = self;
    [_picture setAction:@selector(displayPicture)];
    _picture.target = self;
    [_watermark setAction:@selector(displayWatermark)];
    _generate.target = self;
    [_generate setAction:@selector(displayResult)];
    _save.target = self;
    [_save setAction:@selector(saveResult)];
    }

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(NSImage*)getFile{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setPrompt:@"张熙嘉"];
    [panel setAllowsMultipleSelection:NO];
    [panel isReleasedWhenClosed];
    NSInteger find = [panel runModal];
    if (find == NSModalResponseOK) {
        NSURL *url = [panel URL];
        NSLog(@"%@",url);
        NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
        return image;
    }
    return nil;
}
-(void)displayPicture{
    ViewController *c = [ViewController new];
    NSImage *image = [c getFile];
    [_pictureView setImage:image];
    PICTURE = image;
}
-(void)displayWatermark{
    ViewController *c = [ViewController new];
    NSImage *image = [c getFile];
    [_watermarkView setImage:image];
    WATERMARK = image;
}
-(CGImageRef)NS2CG:(NSImage*)image{
    NSData *data = [image TIFFRepresentation];
    CGImageRef imageRef;
    if (data) {
        CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)data, nil);
        imageRef = CGImageSourceCreateImageAtIndex(source, 0, nil);
        return imageRef;
    }
    return nil;
}
-(NSImage*)CG2NS:(CGImageRef)CGImage{
    NSRect rect = NSMakeRect(0.0, 0.0, CGImageGetWidth(CGImage), CGImageGetHeight(CGImage));
    NSImage *image = [[NSImage alloc] initWithSize:rect.size];
    [image lockFocus];
    CGContextRef context = (CGContextRef) [[NSGraphicsContext currentContext] graphicsPort];
    CGContextDrawImage(context, rect, CGImage);
    [image unlockFocus];
    return image;
}
-(void)generateResult{
    //这一段内存泄漏特别严重，我都快趋势了 2021.10.30
    //尝试用Swift重构 2021.12.03
    ViewController *c = [ViewController new];
    NSImage *picture = PICTURE;
    NSImage *watermark = WATERMARK;
    CGImageRef CGpicture = [c NS2CG:picture];
    CGImageRef CGwatermark = [c NS2CG:watermark];
    CGContextRef context = CGBitmapContextCreate(nil, picture.size.width, picture.size.height, 8, 0, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, picture.size.width, picture.size.height), CGpicture);
    CGContextDrawImage(context, CGRectMake(0, 0, watermark.size.width, watermark.size.height), CGwatermark);
    CGImageRef CGImage = CGBitmapContextCreateImage(context);
    NSImage *image = [c CG2NS:CGImage];
    RESULT = image;
}
-(void)displayResult{
    ViewController *c = [ViewController new];
    ViewControllerSwift *s = [ViewControllerSwift new];
    switch (_renderer.integerValue) {
        case 0:{
            [c generateResult];
            break;
        }
        case 1:{
            NSImage *image = [s generateResultSwiftWithPicture:PICTURE watermark:WATERMARK];
            RESULT = image;
            break;
        }
        default:{
            NSLog(@"Attention! An error was occured when reading the renderer options.");
        }
    }
    [_resultView setImage:RESULT];
}
-(void)saveResult{
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setNameFieldStringValue:@"Result.png"];
    [panel setMessage:@"Choose the save path"];
    [panel setAllowsOtherFileTypes:YES];
    [panel setExtensionHidden:NO];
    [panel setCanCreateDirectories:YES];
    [panel setPrompt:@"张熙嘉"];
    [panel runModal];
        if (panel) {
            NSImage *resultImage = RESULT;
            NSURL *url = [panel URL];
            [[resultImage TIFFRepresentation] writeToURL:url atomically:YES];
        }
}

@end
