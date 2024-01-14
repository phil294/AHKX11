# StringGetPos, OutputVar, InputVar, SearchText [, L#|R#]
class Cmd::String::StringGetPos < Cmd::Base
	def self.min_args; 3 end
	def self.max_args; 4 end
	def self.sets_error_level; true end
	def run(thread, args)
		out_var, in_var, search_text = args
		search_text = Regex.new(Regex.escape(search_text), Regex::Options::IGNORE_CASE)
		opt = (args[3]? || "").downcase
		text = thread.get_var(in_var)
		if opt == "1" || opt == "r"
			i = text.rindex(search_text) || -1
		else
			i = text.index(search_text) || -1
		end
		thread.runner.set_user_var(out_var, i.to_s)
		i == -1 ? "1" : "0"
	end
end