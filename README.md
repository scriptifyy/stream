# stream

A minimal reactive state library for Luau inspired by charm.

## concepts

### streams // `stream(initial: T) -> stream<T>`
A stream is just a function — calling it with no arguments reads the current value, calling it with an argument sets it.
```luau
local stream = require(...)
local coins = stream(0)

print(coins())     --// 0
coins(100)
print(coins())     --// 100
```

This means streams are first-class values. You can pass them around, store them in tables, and call them anywhere without carrying a reference to some object or module.

### channels // `stream.channel(callback: () -> ()) -> channel<T>`
Subscribing to a stream is done via `.channel` on the stream itself. The callback receives no arguments — to read the new value inside a callback, call the stream directly.
```luau
coins.channel(function()
    print(coins())  --// read the new value inside the callback
end)
```

### drains // `channel.drain()`
Closes the channel. The callback will no longer fire when the stream changes.
```luau
local coins = stream(0)

local channel = coins.channel(function()
    print(coins())
end)

coins(100) --// 100
channel.drain()
coins(0)   --// nothing prints
```

