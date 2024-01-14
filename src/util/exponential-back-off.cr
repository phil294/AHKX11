class Util::ExponentialBackOff
	# Waits until the *&block* passes. Increases the sleep time in between operations
	# by *factor*, but sleeps max. *max_interval* seconds. If *max_interval* is unspecified,
	# the waiting gaps can get infinitely big.
	# Returns `true` when the *&block* returns true or `false` when *timeout* was exceeded.
    def self.back_off(*, initial_interval : Time::Span, factor : Float64, max_interval : Time::Span? = nil, timeout : Time::Span? = nil, &block : -> Bool)
		back_off_wait = initial_interval
		start = Time.monotonic
		loop do
			if yield
				break
			end
			if timeout
				if Time.monotonic - start > timeout
					return false
				end
			end
			sleep back_off_wait
			back_off_wait = back_off_wait * factor
			if max_interval
				back_off_wait = ::Math.min(back_off_wait, max_interval)
			end
		end
		true
	end
end