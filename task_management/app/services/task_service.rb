class TaskService
  require 'httparty'

  def start_scraping(task, token)
    return unless task_type_scraping?(task)

    response = HTTParty.post(
      "http://scraping_service:3000/start_scraping",
      headers: {
        'Authorization' => "Bearer #{token}",
        'Content-Type' => 'application/json'
      },
      body: request_body(task).to_json
    )

    handle_response(response,task)
  end

  private

  def task_type_scraping?(task)
    task.task_type == '0'
  end

  def request_body(task)
    {
      task_id: task.id,
      user_id: task.user_id,
      url: task.url
    }
  end

  def handle_response(response,task)
    if response.success?
      puts "Scraping iniciado com sucesso para a tarefa #{task.id}"
    else
      puts "Falha ao iniciar o scraping: #{response.body}"
    end
  end
end
