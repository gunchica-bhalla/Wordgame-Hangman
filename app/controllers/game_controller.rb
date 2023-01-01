class GameController < ApplicationController
  def win
      if @game.check_win_or_lose == :play
          redirect_to game_show_path
      end
  end
  def lose
   if @game.check_win_or_lose == :play
          redirect_to game_show_path
   end
  end

  def show
  end

  def new
  end

  def create
  end

  def guess
  end
  def store_game_in_session
    session[:game] = @game.to_yaml
  end
  def get_game_from_session
    if !session[:game].blank? 
      @game = YAML.load(session[:game])
    else
      @game = WordGame.new('',7)
    end
  end
  before_action :get_game_from_session
  after_action :store_game_in_session
  def create
      word = params[:word] || WordGame.get_random_word
      limit = params[:no_of_guess].to_s
      if limit.to_i < 0 || limit.to_i.to_s!=limit
          flash[:message] = "You must enter a limit of 0 or more."
          redirect_to game_new_path
      elsif limit==nil || limit.empty?
          @game = WordGame.new word,7
          redirect_to game_show_path 
      else
          @game = WordGame.new word,limit
          redirect_to game_show_path 
      end
      
      
  end
  #def limit_set
        #limit = params[:no_of_guess].to_i
        #if limit < 0
           # flash[:message] = "You must enter a limit of 0 or more."
            #redirect_to game_new_path
        #else
       # @guess.limit_set limit
        #end 
   #end
     def guess
    letter = params[:guess].to_s[0]
    
    if @game.guess_illegal_argument? letter
        flash[:message] = "Invalid guess."
    elsif ! @game.guess letter # enter the guess here
        flash[:message] = "You have already used that letter."
    end
    
    if @game.check_win_or_lose == :win
        redirect_to game_win_path
    elsif @game.check_win_or_lose == :lose
        redirect_to game_lose_path
    else    
        redirect_to game_show_path
    end
  end 
end
