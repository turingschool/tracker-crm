class OpenaiGateway

  def generate_interview_questions(description)
    prompt = build_prompt(description)

    response = Faraday.post("https://api.openai.com/v1/chat/completions") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{Rails.application.credentials.dig(:open_ai, :key)}"
      req.body = {
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: prompt }],
        max_tokens: 300,
        temperature: 0.7
      }.to_json
    end

    if response.status == 200
      api_response = JSON.parse(response.body, symbolize_names: true)
      raw_content = api_response.dig(:choices, 0, :message, :content)
      
      cleaned_content = raw_content.match(/\[.*\]/m)&.to_s if raw_content

      if cleaned_content
        {
          success: true,
          id: api_response[:id],
          data: JSON.parse(cleaned_content)
        }
      else
        { success: false, error: "Unexpected response format from OpenAI." }
      end
    else
      { success: false, error: "Failed to fetch interview questions." }
    end
  rescue => error
      { success: false, error: "An error occurred: #{error.message}" }

  end

  private 

  def build_prompt(description)
    "Please generate 10 practice interview questions based on the following job description: #{description}.
    ONLY return a JSON array of strings containing the questions, with no additional formatting or object keys."
  end
end