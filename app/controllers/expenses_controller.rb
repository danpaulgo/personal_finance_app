class ExpensesController < ApplicationController
   def index
    if logged_in?
      @user = current_user
      @expenses = @user.expenses
    else
      redirect_to login_path
    end
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)
    redirect_to @expense if @expense.save
  end

  def edit
    @expense = Expense.find_by(id: params[:id])
  end

  private

    def expense_params
      params.require(:expense).permit(:type, :amount, :frequency)
    end

end
