class RecipesController < ApplicationController
  before_action :logged_in_user, except: [:index, :show]
  before_action :set_params, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @recipes = Recipe.all
  end

  def new
    @recipe = Recipe.new
    6.times { @recipe.ingredients.build } 
    4.times { @recipe.instructions.build }
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    if @recipe.save
      redirect_to recipe_path(@recipe)
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe
    else
      render :edit
    end
  end

  def destroy
    if @recipe.destroy
      flash[:danger] = "Recipe deleted!"
      redirect_to root_path
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :description, ingredients_attributes: [:id, :amount, :user_id, :_destroy],
                                   instructions_attributes: [:id, :step, :body, :user_id,  :_destroy])
  end

  def set_params
    @recipe = Recipe.find(params[:id])
  end

  def require_same_user
    unless current_user?(@recipe.user)
      flash[:danger] = "You must be current user!"
      redirect_to root_path
    end
  end
end
