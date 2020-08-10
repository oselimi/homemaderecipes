class InstructionsController < ApplicationController
    def new
        @recipe = Recipe.find(params[:recipe_id])
        @instruction = @recipe.instructions.build
    end 
    
    def create
        @recipe = Recipe.find(params[:recipe_id])
        @instruction = @recipe.instructions.build(instruction_params)
        @instruction.user = User.first
        
        if @instruction.save
            redirect_to root_path
        else
            render :new
        end
    end

    def show 
        @recipe = Recipe.find(params[:recipe_id])
        @instruction = Instruction.find(params[:id])
    end

    def edit
        @recipe = Recipe.find(params[:recipe_id])
        @instruction = Instruction.find(params[:id])
    end

    def update
        @recipe = Recipe.find(params[:recipe_id])
        @instruction = Instruction.find(params[:id])
        if @instruction.update(instruction_params)
            redirect_to recipe_instruction_path(@recipe, @instruction)
        else
            render :edit
        end
    end

    def destroy
        @recipe = Recipe.find(params[:recipe_id])
        @instruction = Instruction.find(params[:id]).destroy
        redirect_to root_path
    end
    private

    def instruction_params
        params.require(:instruction).permit(:step, :body)
    end
end
