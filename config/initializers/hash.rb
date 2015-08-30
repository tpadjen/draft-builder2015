class Hash
	def to_select(humanize = true)
		if humanize
			to_a.map {|w| [w[0].humanize, w[0]]}
		else
			keys.to_a
		end
	end
end