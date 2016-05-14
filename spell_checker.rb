#
# Class that contains all necessary functionality to perform a spell check on user input.
#
class SpellChecker

	# Initializes necessary data for spell checker by reading a file with a list of words.
	def initialize
		@words_hash = {}
		@vowels     = /[aeiou]/
		read_file
	end

	# Creates a words hash from a list of words, where each letter key maps to an array containing all words that start
	# with that key.
	def read_file
		File.open('./Dictionary/words') do |f|
			f.each_line do |line|
				@words_hash["#{line[0]}"] = [] if @words_hash["#{line[0]}"].nil?
				@words_hash["#{line[0]}"] << line.chomp # Remove new line character
			end 	
		end		
	end 

	# Prompts user for input to spell check, and prints out spell checker's suggestion.
	def get_input
		print '> '
		word = gets.chomp.downcase # Remove new line character, then downcase user input

		puts get_suggestion(word)
	end 

	# Takes user's input, +word+, as a parameter and searches word hash to find most relevant suggestion.
	# Prints out 'NO SUGGESTION' if spell checker could not find a relevant suggestion.
	def get_suggestion(word)
		possible_suggestions = @words_hash["#{word[0]}"] || []

		possible_suggestions.each do |suggestion|
			# Suggestion and input are the same
			return suggestion if suggestion == word

			suggestion_no_vowels = suggestion.gsub(@vowels, '')
			word_no_vowels       = word			 .gsub(@vowels, '')

			# Check length so that we can see if vowels were incorrect
			if suggestion.length == word.length
				return suggestion if suggestion_no_vowels == word_no_vowels

				# Check if input has multiple letters
			else
				suggestion_unique = suggestion_no_vowels.split('').uniq.join
				word_unique		    = word_no_vowels			.split('').uniq.join

				return suggestion if suggestion_unique == word_unique
			end
		end

		'NO SUGGESTION'
	end

	# Main method that prompts user for input until user exits with ^C.
	def run 		
		get_input while true
	end 
end 