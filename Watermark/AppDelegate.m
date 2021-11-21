//
//  AppDelegate.m
//  Watermark
//
//  Created by David 🤴 on 2021/10/22.
//

#import "AppDelegate.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

/*
func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows
flag: Bool) -> Bool {
    if !flag{
        let sb = NSStoryboard(name: "Main", bundle: nil)
        let controller = sb?.instantiateInitialController() as
NSWindowController
        controller.window?.makeKeyAndOrderFront(self)
        self.window = controller.window
    }
    return true
}
*/
-(BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
    if (flag) {
        return NO;
    } else {
        NSStoryboard *main = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
        NSWindowController *controller = [main instantiateInitialController];
        NSWindow *mainWindow = [controller window];
        [mainWindow makeKeyAndOrderFront:self];
        return YES;
    }
}

@end
