class Hash
	def to_select(humanize = true)
		if humanize
			keys.to_a.map {|w| [w.titleize, w]}
		else
			keys.to_a
		end
	end
end