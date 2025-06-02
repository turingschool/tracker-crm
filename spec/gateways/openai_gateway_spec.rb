require 'rails_helper'

RSpec.describe OpenaiGateway do
  describe '#chat_with_gpt' do
    it 'returns success and parsed content when OpenAI responds correctly' do
      fake_prompt = "Tell me a joke."
      fake_response = instance_double(
        Faraday::Response,
        status: 200,
        body: {
          id: "chatcmpl-abc123",
          choices: [
            {
              message: {
                content: "Why did the developer go broke? Because he used up all his cache."
              }
            }
          ]
        }.to_json
      )

      allow(Faraday).to receive(:post).and_return(fake_response)

      gateway = OpenaiGateway.new
      result = gateway.chat_with_gpt(fake_prompt, max_tokens: 150, temperature: 0.5)

      expect(result[:success]).to eq(true)
      expect(result[:id]).to eq("chatcmpl-abc123")
      expect(result[:data]).to eq("Why did the developer go broke? Because he used up all his cache.")
    end

    it 'returns a failure hash when OpenAI returns a 500 error' do
      fake_response = instance_double(Faraday::Response, status: 500, body: "")
      allow(Faraday).to receive(:post).and_return(fake_response)
    
      gateway = OpenaiGateway.new
      result = gateway.chat_with_gpt("broken prompt")
    
      expect(result[:success]).to eq(false)
      expect(result[:error]).to eq("Failed to fetch response from OpenAI.")
    end

    it 'returns a failure hash when the response is missing expected structure' do
      unexpected_json = { wrong_key: "oops" }.to_json
      fake_response = instance_double(Faraday::Response, status: 200, body: unexpected_json)
      allow(Faraday).to receive(:post).and_return(fake_response)
    
      gateway = OpenaiGateway.new
      result = gateway.chat_with_gpt("unexpected format")
    
      expect(result[:success]).to eq(false)
      expect(result[:error]).to eq("Unexpected response format from OpenAI.")
    end
  end

  describe '#transcribe' do
    it 'should return an audio transcription and a successful response code' do
      file = StringIO.new
      response = instance_double(
        Faraday::Response,
        status: 200,
        body: {
          "text": "demo transcription response"
        }.to_json
      )

      allow(Faraday).to receive(:post).and_return(response)

      gateway = OpenaiGateway.new 
      result = gateway.transcribe(file, temperature: 0.2)

      expect(result[:success]).to eq(true)
      expect(result[:data]).to eq({text: "demo transcription response"})
    end
  end
end
