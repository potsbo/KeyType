# KeyType

This app remaps key inputs to another just like Karabiner but with configuration hard code.
Karabiner is more flexible and easier to use but sometimes it sometimes doesn't work with latest macOS.
In those cases I ([@potsbo](https://github.com/potsbo)) use this app to configure key remaps.

I don't any plan to make this app configurable but feel free to fork this project to simulate your own configuration.

## Configuration

With simple DSL-like code like below will do all the configuration.
```swift
let KanaEisu: KeyMapCollection = [
    Remap(Key.commandL.without.command, to: Key.EISU.alone),
    Remap(Key.commandR.without.command, to: Key.KANA.alone),
]

let Emacs = [
    [Key.ctrlL.without.ctrl, Key.ESCAPE.alone],
    [Key.J.with.ctrl, Key.RETURN.alone],
    [Key.M.with.ctrl, Key.RETURN.alone],
    [Key.F.with.ctrl, Key.RIGHT_ARROW.alone],
    [Key.B.with.ctrl, Key.LEFT_ARROW.alone],
    [Key.N.with.ctrl, Key.DOWN_ARROW.alone],
    [Key.P.with.ctrl, Key.UP_ARROW.alone],
    [Key.H.with.ctrl, Key.DELETE.alone],
].map { Remap($0[0], to: $0[1]) }
```
