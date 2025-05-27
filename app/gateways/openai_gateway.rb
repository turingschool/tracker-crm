class OpenaiGateway
  def chat_with_gpt(prompt, max_tokens: 300, temperature: 0.7)
    response = Faraday.post("https://api.openai.com/v1/chat/completions") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{Rails.application.credentials.dig(:open_ai, :key)}"
      req.body = {
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: prompt }],
        max_tokens: max_tokens,
        temperature: temperature
      }.to_json
    end

    if response.status == 200
      api_response = JSON.parse(response.body, symbolize_names: true)
      raw_content = api_response.dig(:choices, 0, :message, :content)

      if raw_content.nil?
        return { success: false, error: "Unexpected response format from OpenAI." }
      end
      
      {
        success: true,
        id: api_response[:id],
        data: raw_content
      }
    else
      { success: false, error: "Failed to fetch response from OpenAI." }
    end
  rescue => error
    { success: false, error: "An error occurred: #{error.message}" }
  end
end

  