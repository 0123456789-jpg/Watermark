//
//  ViewController.m
//  Watermark
//
//  Created by David 🤴 on 2021/10/22.
//

#import "ViewController.h"
#import "Watermark-Swift.h"

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
}
-(void)displayWatermark{
    ViewController *c = [ViewController new];
    NSImage *image = [c getFile];
    [_watermarkView setImage:image];
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
-(NSImage*)generateResultWithPicture:(NSImage*)picture AndWatermark:(NSImage*)watermark{
    //这一段内存泄漏特别严重，我都快趋势了 2021.10.30
    //尝试用Swift重构 2021.12.03
    ViewController *c = [ViewController new];
    CGImageRef CGpicture = [c NS2CG:picture];
    CGImageRef CGwatermark = [c NS2CG:watermark];
    CGContextRef context = CGBitmapContextCreate(nil,picture.size.width, picture.size.height, 8, 0, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, picture.size.width, picture.size.height), CGpicture);
    CGContextDrawImage(context, CGRectMake(0, 0, watermark.size.width, watermark.size.height), CGwatermark);
    return [c CG2NS:CGBitmapContextCreateImage(context)];
}
-(NSImage*)genResNewWithPicture:(NSImage*)picture AndWatermark:(NSImage*)watermark{
    NSBitmapImageRep *watermarkRep = [[NSBitmapImageRep alloc] initWithData:[watermark TIFFRepresentation]];
    [picture lockFocus];
    [watermarkRep drawInRect:NSMakeRect(0, 0, watermark.size.width, watermark.size.height)];
    [picture unlockFocus];
    return picture;
    //2021.12.18 WDNMD两个月心血居然用4行代码就能实现，还TM不用内存管理
}
-(void)displayResult{
    ViewController *c = [ViewController new];
    ViewControllerSwift *s = [ViewControllerSwift new];
    NSImage *image;
    switch (_renderer.integerValue) {
        case 0:{
            image = [c generateResultWithPicture:[_pictureView image] AndWatermark:[_watermarkView image]];
            break;
        }
        case 1:{
            image = [s generateResultSwiftWithPicture:[_pictureView image] watermark:[_watermarkView image]];
            NSImageRep *imageRep = [image bestRepresentationForRect:NSMakeRect(0, 0, _pictureView.image.size.width, _pictureView.image.size.height) context:nil hints:nil];
            NSImage *tempImage = [[NSImage alloc] initWithSize:NSMakeSize(_pictureView.image.size.width, _pictureView.image.size.height)];
            [tempImage lockFocus];
            [imageRep drawInRect:NSMakeRect(0, 0, _pictureView.image.size.width, _pictureView.image.size.height)];
            [tempImage unlockFocus];
            image = tempImage;
            break;
        }
        case 2:{
            image = [c genResNewWithPicture:[_pictureView image] AndWatermark:[_watermarkView image]];
            break;
        }
        default:{
            NSLog(@"Attention! An error was occured while reading the renderer options.");
            break;
        }
    }
    [_resultView setImage:image];
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
            NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:[[_resultView image] TIFFRepresentation]];
            [[imageRep representationUsingType:NSPNGFileType properties:[[NSDictionary alloc] init]] writeToURL:[panel URL] atomically:YES];
        }
}

@end
