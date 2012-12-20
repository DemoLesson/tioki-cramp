module ModelUtils
	def pluralize(num, word)
		"#{num} #{word}" + (num == 1 ? '' : 's')
	end

	def relative_time(timestamp)
		minutes = (((Time.now - timestamp).abs)/60).round

		return 'just now' if minutes < 1

		case minutes
		when 1..4            then 'a few minutes ago'
		when 5..59           then "about #{minutes}"
		when 60..119         then 'over 1 hour ago'
		when 120..239        then 'over 2 hours ago'
		when 240..479        then 'over 4 hours ago'
		when 480..719        then 'over 8 hours ago'
		when 720..1439       then 'over 12 hours ago'
		when 1440..11519     then 'over ' << pluralize((minutes/1440).floor, 'day') << ' ago'
		when 11520..43199    then 'over ' << pluralize((minutes/11520).floor, 'week') << ' ago'
		when 43200..525599   then 'over ' << pluralize((minutes/43200).floor, 'month') << ' ago'
		else                      'over ' << pluralize((minutes/525600).floor, 'year') << ' ago'
		end
	end
end