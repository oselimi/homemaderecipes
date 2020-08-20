class IngredientsController < ApplicationController
  before_action :logged_in_user
  before_action :set_params, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user, except: :show
  def new
    @recipe = Recipe.find(params[:recipe_id])
    @ingredient = @recipe.ingredients.build
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @ingredient = @recipe.ingredients.build(ingredient_params)
    @ingredient.user = current_user

    if @ingredient.save
      redirect_to @ingredient.recipe
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @ingredient.update(ingredient_params)
      redirect_to recipe_path(@recipe, @ingredient)
    else
      render :new
    end
  end

  def destroy
    if @ingredient.destroy
      redirect_to recipe_path(@recipe, @ingredient)
    end
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:amount)
  end

  def set_params
    @recipe = Recipe.find(params[:recipe_id])
    @ingredient = Ingredient.find(params[:id])
  end

  def require_same_user
    unless current_user?(@ingredient.user)
      flash[:danger] = 'You must be current user!'
      redirect_to root_path
    end
  end
end
