# If var not in value1,value2,...
class Cmd::ControlFlow::IfNotIn < Cmd::Base
	def self.min_args; 2 end
	def self.max_args; 2 end
	def self.conditional; true end
	def run(thread, args)
		txt = (thread.get_var(args[0]) || "").downcase
		matches = args[1].downcase.gsub(",,", "\0").split(",").map &.gsub("\0", ",")
		! matches.index(txt)
	end
end