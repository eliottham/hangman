class Hangman
	def initialize
		generate_word
		@hidden_letters = Array.new(@word.size, '_')
		@incorrect_guess = Array.new
		@error = 0
		@man = ['|----|', '|', '|', '|', '|', '|']
	end

	def generate_word
		array_of_words = File.readlines("5desk.txt")
		array_of_words = array_of_words.keep_if { |word| word.size >= 5 && word.size <= 12 }
		@word = array_of_words.sample.delete!("\r\n").split(//)
	end

	def make_guess
		puts "Enter a letter:"
		@guess = gets.chomp.downcase
		if @incorrect_guess.any? { |letter| letter == @guess }
			puts "You already guessed '#{@guess}'! Try again."
			make_guess
		elsif @guess.size != 1 || (@guess =~ /[a-z]/) == nil
			puts "Invalid choice. Try again."
			make_guess
		end
	end

	def check_guess
		@word.each_with_index do |letter, index| 
			if letter == @guess
				@hidden_letters[index] = @guess
			end
		end
		if (@word.find { |letter| letter == @guess }) == nil
			@incorrect_guess.push(@guess)
			@error += 1
			update_man
		end
	end

	def display
		@man.each do | x |
			puts x
		end
		puts "Letters guessed: #{@incorrect_guess.join(' ')}"
		puts "Word: #{@hidden_letters.join(' ')}"
	end

	def update_man
		case @error
		when 1
			@man[1] = '|    O'
		when 2
			@man[2] = '|    |'
		when 3
			@man[2] = '|   /|'
		when 4
			@man[2] = '|   /|\\'
		when 5
			@man[3] = '|   /'
		when 6
			@man[3] = '|   / \\'
		end
	end

	def game_over?
		if @error == 6
			display
			puts "Your poor vocabulary cost a good man his life."
			return true
		end
		if @hidden_letters.all? { |letter| letter != '_' }
			puts "You saved him!"
			return true
		end
	end

	def game
		until game_over?
			display
			make_guess
			check_guess
		end
	end

end





game = Hangman.new
game.game

