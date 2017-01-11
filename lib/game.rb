class Game
	require_relative "hangman"
	require "yaml"

	def initialize
		@game = Hangman.new
	end

	def save_option
		puts "Do you want to save the current game? (y/n)"
		response = gets.chomp
		if (response =~ /[y || n]/) == nil
			puts "Invalid response. Type 'y' for yes, 'n' for no."
			save_option
		elsif response == 'y'
			save_file
		end
	end

	def save_file
		time = Time.new.strftime("%Y_%j_%H_%M_%S")
		filename = time.to_s + ".txt"
		puts "Your save file is named #{filename}"

		Dir.mkdir("save_files") unless Dir.exists?("save_files")
		
		File.open("save_files/#{filename}", 'w') do |file|
			file.puts YAML::dump(@game)
		end
	end

	def load_file
		puts "Would you like to load a previous game? (y/n)"
		saved_games = Dir.entries("save_files").select { |f| !File.directory? f }
		puts saved_games
		response = gets.chomp
		if (response =~ /[y || n]/) == nil
			puts "Invalid response. Type 'y' for yes, 'n' for no."
			load_file
		elsif response == 'y'
			puts "Enter the name of your save file."
			save_name = gets.chomp
			if saved_games.find { |title| title == save_name } == nil
				puts "There is no save file with that name. Try again."
				load_file
			else
			loaded_game = YAML.load(File.open("save_files/#{save_name}"))
			@game = loaded_game
			end
		end
	end

	def play
		load_file
		until @game.game_over?
			@game.display
			@game.make_guess
			@game.check_guess
			@game.display
			save_option
		end
	end
end

round = Game.new
round.play


