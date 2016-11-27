//
//  Key.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Cocoa

enum Key : UInt16 {
    case A = 0
    case S = 1
    case D = 2
    case F = 3
    case H = 4
    case G = 5
    case Z = 6
    case X = 7
    case C = 8
    case V = 9
    case DANISH_DOLLAR = 10
    case B = 11
    case Q = 12
    case W = 13
    case E = 14
    case R = 15
    case Y = 16
    case T = 17
    case NUM1  = 18
    case NUM2  = 19
    case NUM3  = 20
    case NUM4  = 21
    case NUM6  = 22
    case NUM5  = 23
    case EQUAL = 24
    case NUM9  = 25
    case NUM7  = 26
    case MINUS = 27
    case NUM8  = 28
    case NUM0  = 29
    case SQUARE_KET = 30
    case O = 31
    case U = 32
    case SQUARE_BRA = 33
    case I = 34
    case P = 35
    case RETURN = 36
    case L = 37
    case J = 38
    case QUOTE = 39
    case K = 40
    case SEMICOLON = 41
    case BACKSLASH = 42
    case COMMA     = 43
    case SLASH     = 44
    case N = 45
    case M = 46
    case PERIOD    = 47
    case TAB       = 48
    case SPACE     = 49
    case BACKQUOTE = 50
    case DELETE    = 51
    case ENTER_POWERBOOK = 52
    case ESCAPE    = 53
    case COMMAND_R = 54
    case COMMAND_L = 55
    case SHIFT_L   = 56
    case CAPSLOCK  = 57
    case OPTION_L  = 58
    case CONTROL_L = 59
    case SHIFT_R   = 60
    case OPTION_R  = 61
    case CONTROL_R = 62
    case FN  = 63
    case F17 = 64
    case KEYPAD_DOT      = 65
    case KEYPAD_MULTIPLY = 67
    case KEYPAD_PLUS     = 69
    case KEYPAD_CLEAR    = 71
    case KEYPAD_SLASH    = 75
    case KEYPAD_ENTER    = 76
    case KEYPAD_Minus    = 78
    case F18 = 79
    case F19 = 80
    case KEYPAD_EQUAL = 81
    case KEYPAD_0 = 82
    case KEYPAD_1 = 83
    case KEYPAD_2 = 84
    case KEYPAD_3 = 85
    case KEYPAD_4 = 86
    case KEYPAD_5 = 87
    case KEYPAD_6 = 88
    case KEYPAD_7 = 89
    case F20 = 90
    case KEYPAD_8 = 91
    case KEYPAD_9 = 92
    case YEN = 93
    case UNDER_SCORE = 94
    case KEYPAD_Comma = 95
    case F5    = 96
    case F6    = 97
    case F7    = 98
    case F3    = 99
    case F8    = 100
    case F9    = 101
    case EISU  = 102
    case F11   = 103
    case KANA  = 104
    case F13   = 105
    case F16   = 106
    case F14   = 107
    case F10   = 109
    case App   = 110
    case F12   = 111
    case F15   = 113
    case HELP  = 114
    case HOME  = 115
    case PG_UP = 116
    case BACKSPACE   = 117
    case F4          = 118
    case END         = 119
    case F2          = 120
    case PG_DOWN     = 121
    case F1          = 122
    case LEFT_ARROW  = 123
    case RIGHT_ARROW = 124
    case DOWN_ARROW  = 125
    case UP_ARROW    = 126
    case PC_POWER    = 127
    case GERMAN_PC_LESS_THAN = 128
    case DASHBOARD           = 130
    case LAUNCHPAD           = 131
    case BRIGHTNESS_UP       = 144
    case BRIGHTNESS_DOWN     = 145
    case EXPOSE_ALL          = 160
    
    static func numbers() -> [Key] {
        return [.NUM1, .NUM2, .NUM3, .NUM4, .NUM5, .NUM6, .NUM7, .NUM8, .NUM9, .NUM0]
    }
}
