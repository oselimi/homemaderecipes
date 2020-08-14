class InstructionsController < ApplicationController
  before_action :logged_in_user
  before_action :set_params, only: [:show, :edit, :update, :destroy]
  def new
    @recipe = Recipe.find(params[:recipe_id])
    @instruction = @recipe.instructions.build
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @instruction = @recipe.instructions.build(instruction_params)
    @instruction.user = current_user

    if @instruction.save
      redirect_to @instruction.recipe
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @instruction.update(instruction_params)
      redirect_to recipe_instruction_path(@recipe, @instruction)
    else
      render :edit
    end
  end

  def destroy
    if @instruction.destroy
      redirect_to root_path
    end
  end

  private

  def instruction_params
    params.require(:instruction).permit(:step, :body)
  end

  def set_params
    @recipe = Recipe.find(params[:recipe_id])
    @instruction = Instruction.find(params[:id])
  end
end