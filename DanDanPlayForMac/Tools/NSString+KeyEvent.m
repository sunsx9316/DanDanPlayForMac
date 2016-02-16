//
//  NSString+KeyEvent.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "NSString+KeyEvent.h"

@implementation NSString (KeyEvent)

+ (NSString*) specialKeycodeToString:(NSEvent*)event
{
    unsigned short keycode = [event keyCode];
    
    if (keycode == 0x35) return @"Escape";
    if (keycode == 0x36) return @"Right Command";
    if (keycode == 0x37) return @"Left Command";
    if (keycode == 0x38) return @"Left Shift";
    if (keycode == 0x39) return @"CapsLock";
    if (keycode == 0x3a) return @"Left Option";
    if (keycode == 0x3b) return @"Left Control";
    if (keycode == 0x3c) return @"Right Shift";
    if (keycode == 0x3d) return @"Right Option";
    if (keycode == 0x3e) return @"Right Control";
    if (keycode == 0x3f) return @"Fn";
    
    if (keycode == 0x24) return @"Return";
    if (keycode == 0x30) return @"Tab";
    if (keycode == 0x31) return @"Space";
    if (keycode == 0x33) return @"Delete";
    if (keycode == 0x4c) return @"Enter";
    if (keycode == 0x66) return @"JIS_EISUU";
    if (keycode == 0x68) return @"JIS_KANA";
    if (keycode == 0x6e) return @"Application";
    
    // ------------------------------------------------------------
    @try {
        NSString* characters = [event characters];
        if ([characters length] > 0) {
            unichar unichar = [characters characterAtIndex:0];
            
            if (unichar == NSUpArrowFunctionKey)    { return @"Up";    }
            if (unichar == NSDownArrowFunctionKey)  { return @"Down";  }
            if (unichar == NSLeftArrowFunctionKey)  { return @"Left";  }
            if (unichar == NSRightArrowFunctionKey) { return @"Right"; }
            
            if (unichar == NSF1FunctionKey)  { return @"F1";  }
            if (unichar == NSF2FunctionKey)  { return @"F2";  }
            if (unichar == NSF3FunctionKey)  { return @"F3";  }
            if (unichar == NSF4FunctionKey)  { return @"F4";  }
            if (unichar == NSF5FunctionKey)  { return @"F5";  }
            if (unichar == NSF6FunctionKey)  { return @"F6";  }
            if (unichar == NSF7FunctionKey)  { return @"F7";  }
            if (unichar == NSF8FunctionKey)  { return @"F8";  }
            if (unichar == NSF9FunctionKey)  { return @"F9";  }
            if (unichar == NSF10FunctionKey) { return @"F10"; }
            if (unichar == NSF11FunctionKey) { return @"F11"; }
            if (unichar == NSF12FunctionKey) { return @"F12"; }
            if (unichar == NSF13FunctionKey) { return @"F13"; }
            if (unichar == NSF14FunctionKey) { return @"F14"; }
            if (unichar == NSF15FunctionKey) { return @"F15"; }
            if (unichar == NSF16FunctionKey) { return @"F16"; }
            if (unichar == NSF17FunctionKey) { return @"F17"; }
            if (unichar == NSF18FunctionKey) { return @"F18"; }
            if (unichar == NSF19FunctionKey) { return @"F19"; }
            if (unichar == NSF20FunctionKey) { return @"F20"; }
            if (unichar == NSF21FunctionKey) { return @"F21"; }
            if (unichar == NSF22FunctionKey) { return @"F22"; }
            if (unichar == NSF23FunctionKey) { return @"F23"; }
            if (unichar == NSF24FunctionKey) { return @"F24"; }
            if (unichar == NSF25FunctionKey) { return @"F25"; }
            if (unichar == NSF26FunctionKey) { return @"F26"; }
            if (unichar == NSF27FunctionKey) { return @"F27"; }
            if (unichar == NSF28FunctionKey) { return @"F28"; }
            if (unichar == NSF29FunctionKey) { return @"F29"; }
            if (unichar == NSF30FunctionKey) { return @"F30"; }
            if (unichar == NSF31FunctionKey) { return @"F31"; }
            if (unichar == NSF32FunctionKey) { return @"F32"; }
            if (unichar == NSF33FunctionKey) { return @"F33"; }
            if (unichar == NSF34FunctionKey) { return @"F34"; }
            if (unichar == NSF35FunctionKey) { return @"F35"; }
            
            if (unichar == NSInsertFunctionKey)       { return @"Insert";           }
            if (unichar == NSDeleteFunctionKey)       { return @"Forward Delete";   }
            if (unichar == NSHomeFunctionKey)         { return @"Home";             }
            if (unichar == NSBeginFunctionKey)        { return @"Begin";            }
            if (unichar == NSEndFunctionKey)          { return @"End";              }
            if (unichar == NSPageUpFunctionKey)       { return @"Page Up";          }
            if (unichar == NSPageDownFunctionKey)     { return @"Page Down";        }
            if (unichar == NSPrintScreenFunctionKey)  { return @"Print Screen";     }
            if (unichar == NSScrollLockFunctionKey)   { return @"Scroll Lock";      }
            if (unichar == NSPauseFunctionKey)        { return @"Pause";            }
            if (unichar == NSSysReqFunctionKey)       { return @"System Request";   }
            if (unichar == NSBreakFunctionKey)        { return @"Break";            }
            if (unichar == NSResetFunctionKey)        { return @"Reset";            }
            if (unichar == NSStopFunctionKey)         { return @"Stop";             }
            if (unichar == NSMenuFunctionKey)         { return @"Menu";             }
            if (unichar == NSUserFunctionKey)         { return @"User";             }
            if (unichar == NSSystemFunctionKey)       { return @"System";           }
            if (unichar == NSPrintFunctionKey)        { return @"Print";            }
            if (unichar == NSClearLineFunctionKey)    { return @"Clear/Num Lock";   }
            if (unichar == NSClearDisplayFunctionKey) { return @"Clear Display";    }
            if (unichar == NSInsertLineFunctionKey)   { return @"Insert Line";      }
            if (unichar == NSDeleteLineFunctionKey)   { return @"Delete Line";      }
            if (unichar == NSInsertCharFunctionKey)   { return @"Insert Character"; }
            if (unichar == NSDeleteCharFunctionKey)   { return @"Delete Character"; }
            if (unichar == NSPrevFunctionKey)         { return @"Previous";         }
            if (unichar == NSNextFunctionKey)         { return @"Next";             }
            if (unichar == NSSelectFunctionKey)       { return @"Select";           }
            if (unichar == NSExecuteFunctionKey)      { return @"Execute";          }
            if (unichar == NSUndoFunctionKey)         { return @"Undo";             }
            if (unichar == NSRedoFunctionKey)         { return @"Redo";             }
            if (unichar == NSFindFunctionKey)         { return @"Find";             }
            if (unichar == NSHelpFunctionKey)         { return @"Help";             }
            if (unichar == NSModeSwitchFunctionKey)   { return @"Mode Switch";      }
        }
    } @catch (NSException* exception) {}
    
    return nil;
}

+ (NSString*) stringWithKeyEventCharactersIgnoringModifiers:(NSEvent*)event
{
    NSString* string = [self specialKeycodeToString:event];
    if (string) return string;
    
    // --------------------
    // Difference of "characters" and "charactersIgnoringModifiers".
    //
    // [NSEvent characters]
    //   Option+z => Ω
    //
    // [NSEvent charactersIgnoringModifiers]
    //   Option+z => z
    //
    // We prefer "Shift+Option+z" style than "Shift+Ω".
    // Therefore we use charactersIgnoringModifiers here.
    //
    // --------------------
    // However, there is a problem.
    // When we use "Dvorak - Qwerty ⌘" as Input Source,
    // charactersIgnoringModifiers returns ';'.
    // It's wrong. Input Source does not change Command+z.
    // So, we need to use 'characters' in this case.
    //
    // [NSEvent characters]
    //    Command+z => z
    // [NSEvent charactersIgnoringModifierss]
    //    Command+z => ;
    //
    //
    // --------------------
    // But, we cannot use these properly without information about current Input Source.
    // And this information cannot get by program.
    //
    // So, we use charactersIgnoringModifierss here and
    // display the result of 'characters' in the 'misc' field.
    
    @try {
        return [[event charactersIgnoringModifiers] uppercaseString];
    } @catch (NSException* exception) {}
    return @"";
}

@end