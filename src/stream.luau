export type channel<T> = {
	drain: () -> (),
}

export type stream<T> = typeof(setmetatable(
	{} :: {
		channel: (callback: () -> ()) -> channel<T>,
	},
	{} :: {
		__call: (self: any, value: T?) -> T,
	}
))

local function stream<T>(initial: T): stream<T>
	local value = initial
	local channels: { () -> () } = {}
	local is_flowing = false

	local function channel(callback: () -> ()): channel<T>
		table.insert(channels, callback)

		local function drain()
			for i = 1, #channels do
				if channels[i] == callback then
					table.remove(channels, i)
					break
				end
			end
		end

		return {
			drain = drain 
		}
	end

	local function flow(...: T?): T
		if select("#", ...) > 0 then
			local new_value = (...) :: T

			if new_value == value then
				return value
			end

			if is_flowing then
				return value
			end

			value = new_value
			is_flowing = true

			local snapshot = table.clone(channels)
			for i = 1, #snapshot do
				snapshot[i](value)
			end

			is_flowing = false
		end

		return value
	end

	return setmetatable({
		channel = channel
	}, {
		__call = function(_, ...)
			return flow(...)
		end
	})
end

return stream
