class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  # GET /tasks
  def index
    @tasks = Task.all
    render json: @tasks
  end

  # GET /tasks/:id
  def show
    render json: @task
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save

      token = request.headers['Authorization']&.split(' ')&.last
      response = HTTParty.post(
        "http://notification_service:3000/notifications",
        headers: {
          'Authorization' => "Bearer #{token}",
          'Content-Type' => 'application/json'
        },
        body: {
          task_id: @task.id,
          user_id: @task.user_id,
          action: "create",
          details: "Task was created successfully."
        }.to_json
      )

      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/:id
  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/:id
  def destroy
    @task.destroy
    head :no_content
  end

  private

  # Set the task for actions that require it
  def set_task
    @task = Task.find(params[:id])
  end

  # Strong parameters
  def task_params
    params.require(:task).permit(:url, :status, :user_id, :task_type)
  end
end
