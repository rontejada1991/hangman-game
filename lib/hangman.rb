require 'yaml'

class SecretWord
  attr_accessor :secret_word_so_far
  attr_reader :secret_word

  def initialize(all_lines)
    @valid_lines = min_max_filter(all_lines, 5, 12)
    @secret_word = @valid_lines[rand(@valid_lines.length)].split("")
    @secret_word_so_far = Array.new(@secret_word.length, "_")
  end

  def min_max_filter(lines, min, max)
    lines.select do |line|
      line = line.chomp!
      line.length >= min && line.length <= max
    end
  end

  def words_match
    @secret_word.join == @secret_word_so_far.join
  end

  def letters_match?(letter)
    # Temporary downcase for comparative reasons
    secret_word_downcase = @secret_word.collect { |c| c.downcase }

    if secret_word_downcase.include?(letter)
      secret_word_downcase.each_index do |i|
        if secret_word_downcase[i] == letter
          @secret_word_so_far[i] = @secret_word[i]
        end
      end
      return true
    else
      return false
    end
  end
end

class Player
  attr_accessor :correct_guesses, :incorrect_guesses, :correct_letters, :incorrect_letters

  def initialize
    @correct_guesses = 0
    @incorrect_guesses = 0
    @incorrect_letters = Array.new
  end

  def guess
    input = gets.downcase.chomp
  end
end

class Game
  def initialize
    @dictionary = File.open("5desk.txt", "r")
    @all_lines = @dictionary.readlines
    load_game
  end

  def display
    puts "Word: #{@word.secret_word_so_far.join(' ')}"
    puts "Misses: #{@player.incorrect_letters.join(' ')}"
    print "Guess: " unless @word.words_match
  end

  def results
    if @word.words_match
      display
      puts "WE HAVE A WINNER"
    else
      puts "GAME OVER"
      puts "The secret word was #{@word.secret_word.join(' ')}"
    end
  end

  def gameover?
    if @word.words_match || @player.incorrect_guesses > 9
      return true
    else
      return false
    end
  end

  def load_game
    puts "Its the classic game of Hangman!"
    puts "To save during a game, enter \'save\'"
    puts "To load a game now, enter \'load\'"
    puts "Otherwise, hit enter to begin!"

    player_input = gets.downcase.chomp

    # Load game if file exists
    if player_input == 'load' && File.file?("save_file.yaml")
      puts "Loading..."
      File.open("save_file.yaml", "r") do |file|
        saved_objects = YAML::load(file.read)
        # If loading additional files, it would be wise to use an array to assign them instead
        @word = saved_objects[0]
        @player = saved_objects[1]
        puts "Successfully loaded save file."
      end
    else
      # New game
      @word = SecretWord.new(@all_lines)
      @player = Player.new
    end

    game_loop
  end

  def save_game
    save_objects = [@word, @player]
    yaml = YAML::dump(save_objects)
    File.open("save_file.yaml", "w") do |save_file|
      save_file.write(yaml)
    end
  end

  def game_loop
    while !gameover?
      display

      player_input = @player.guess
      
      if player_input == "save"
        puts "Saving..."
        save_game
        puts "Successfully saved game."
      else
        correct_input = @word.letters_match?(player_input)
      end
      
      if correct_input
        @player.correct_guesses += 1
      else
        @player.incorrect_guesses += 1
        @player.incorrect_letters << player_input
      end
    end
    results
  end
end

new_game = Game.new