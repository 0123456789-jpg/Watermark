//
//  ViewController.m
//  Watermark
//
//  Created by David 🤴 on 2021/10/22.
//

#import "ViewController.h"

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
    [c generateResult];
    [_resultView setImage:RESULT];
}

@end
