function scr_keytostring(_key) {
	//if already a string, return formatted in uppercase
    if (is_string(_key)) {
        return string_upper(_key);
    }
    
    //check vk constants
    switch (_key) {
        //basic
        case vk_left:        return "LEFT";
        case vk_right:       return "RIGHT";
        case vk_up:          return "UP";
        case vk_down:        return "DOWN";
        case vk_space:       return "SPACE";
        case vk_enter:       return "ENTER";
        case vk_return:      return "ENTER";
        case vk_escape:      return "ESCAPE";
        case vk_shift:       return "SHIFT";
        case vk_lshift:      return "L-SHIFT";
        case vk_rshift:      return "R-SHIFT";
        case vk_control:     return "CTRL";
        case vk_lcontrol:    return "L-CTRL";
        case vk_rcontrol:    return "R-CTRL";
        case vk_alt:         return "ALT";
        case vk_backspace:   return "BACKSPACE";
        case vk_tab:         return "TAB";
        case vk_home:        return "HOME";
        case vk_end:         return "END";
        case vk_delete:      return "DELETE";
        case vk_insert:      return "INSERT";
        case vk_pageup:      return "PAGE UP";
        case vk_pagedown:    return "PAGE DOWN";
        case vk_printscreen: return "PRNT SCRN";
        
        //fn keys
        case vk_f1:          return "F1";
        case vk_f2:          return "F2";
        case vk_f3:          return "F3";
        case vk_f4:          return "F4";
        case vk_f5:          return "F5";
        case vk_f6:          return "F6";
        case vk_f7:          return "F7";
        case vk_f8:          return "F8";
        case vk_f9:          return "F9";
        case vk_f10:         return "F10";
        case vk_f11:         return "F11";
        case vk_f12:         return "F12";
        
        //numpad
        case vk_numpad0:     return "NUM 0";
        case vk_numpad1:     return "NUM 1";
        case vk_numpad2:     return "NUM 2";
        case vk_numpad3:     return "NUM 3";
        case vk_numpad4:     return "NUM 4";
        case vk_numpad5:     return "NUM 5";
        case vk_numpad6:     return "NUM 6";
        case vk_numpad7:     return "NUM 7";
        case vk_numpad8:     return "NUM 8";
        case vk_numpad9:     return "NUM 9";
        case vk_divide:  return "NUM /";
        case vk_multiply:  return "NUM *";
        case vk_subtract:  return "NUM -";
        case vk_add:  return "NUM +";
        case vk_decimal: return "NUM .";
        
        default:
            //if it's a standard ASCII/ord value (like ord("D")), convert it via chr()
            if (_key >= 0 && _key <= 255) {
                var _char = chr(_key);
                
                // Safe lookup table translating symbols you might be missing in your font
                switch (_char) {
                    case "-":  return "MINUS";
                    case "+":  return "PLUS";
                    case "=":  return "EQUALS";
                    case "_":  return "UNDERSCORE";
                    case "[":  return "LEFT BRACKET";
                    case "]":  return "RIGHT BRACKET";
                    case "{":  return "LEFT BRACE";
                    case "}":  return "RIGHT BRACE";
                    case "\\": return "BACKSLASH";
                    case "/":  return "SLASH";
                    case ";":  return "SEMICOLON";
                    case ":":  return "COLON";
                    case "'":  return "APOSTROPHE";
                    case "\"": return "QUOTE";
                    case ",":  return "COMMA";
                    case ".":  return "PERIOD";
                    case "<":  return "LESS THAN";
                    case ">":  return "GREATER THAN";
                    case "?":  return "QUESTION MARK";
                    case "`":  return "TILDE";
                    case "~":  return "TILDE";
                    case "!":  return "EXCLAMATION";
                    case "@":  return "AT";
                    case "#":  return "HASH";
                    case "$":  return "DOLLAR";
                    case "%":  return "PERCENT";
                    case "^":  return "CARET";
                    case "&":  return "AMPERSAND";
                    case "*":  return "ASTERISK";
                    case "(":  return "L-PARENTHESIS";
                    case ")":  return "R-PARENTHESIS";
                    case " ":  return "SPACE";
                    default:   return _char;
            }
	    }
	}
}