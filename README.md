# stream

A minimal reactive state library for Luau.

## API

### `stream(initial)`

Creates a new stream with an initial value. Returns a callable that reads or writes the value.
```luau
local coins = stream(0)

coins()     -- read  → 0
coins(100)  -- write → 100
```

### `stream.channel(s, callback)`

Subscribes to a stream. Fires `callback` whenever the value changes. Returns a `channel`.
```luau
local ch = stream.channel(coins, function(val)
    print(val)
end)
```

> A single stream can have multiple channels open at the same time.

### `channel.drain()`

Unsubscribes the channel so it stops receiving updates.
```luau
ch.drain()
```