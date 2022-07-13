module Run
    # ahk threads are no real threads but pretty much like crystal fibers, except they're not
    # cooperative at all; they take each other's place (prioritized) and continue until their invididual end.
    # Threads never really run in parallel: There's always one "current thread"
    class Thread
        getter runner : Runner
        @stack = [] of Cmd
        getter priority = 0
        @exit_code = 0
        @result_channel : Channel(Int32?)?
        def initialize(@runner, start, @priority = 0)
            @stack << start
        end

        protected def next
            result_channel = @result_channel
            return result_channel if result_channel
            result_channel = @result_channel = Channel(Int32?).new
            spawn do
                result = do_next
                result_channel.send(result)
                result_channel.close
                @result_channel = nil
                result
            end
            result_channel
        end
        # returns exit code or nil if this thread isn't done yet
        private def do_next
            ins = @stack.last?
            return @exit_code if ! ins
            stack_i = @stack.size - 1

            result = ins.run(self)

            next_ins = ins.next
            if ins.class.control_flow
                if result
                    next_ins = ins.je
                else
                    next_ins = ins.jne
                end
            end
            # current stack el may have been altered by prev ins.run(), in which case disregard the normal flow
            if @stack[stack_i]? == ins # not altered
                if ! next_ins
                    @stack.delete_at(stack_i)
                else
                    @stack[stack_i] = next_ins
                end
            end
            nil
        end

        def gosub(label)
            cmd = @runner.labels[label]?
            raise RuntimeException.new "gosub: label '#{label}' not found" if ! cmd
            @stack << cmd
        end
        def goto(label)
            cmd = @runner.labels[label]?
            raise RuntimeException.new "goto: label '#{label}' not found" if ! cmd
            @stack[@stack.size - 1] = cmd
        end
        def return
            @stack.pop
        end
        def exit(code)
            @exit_code = code || 0
            @stack.clear
        end
    end
end