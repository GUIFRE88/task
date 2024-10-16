# frozen_string_literal: true

require 'nokogiri'
require 'puppeteer-ruby'

class ScrapService
  def scrape(url)
    Puppeteer.launch(headless: true, args: ['--no-sandbox']) do |browser|
      page = browser.new_page

      user_agents = [
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0.2 Safari/605.1.15'
      ]
      page.set_user_agent(user_agents.sample)

      page.goto(url, wait_until: 'networkidle2')

      if page.title.include?("Error")
        raise "Failed to retrieve the webpage. Status code: #{page.status}"
      end

      html = page.content
      parsed_page = Nokogiri::HTML(html)

      brand = parsed_page.at_css('#VehicleBasicInformationTitle')&.text&.strip || "Marca não encontrada"
      model = parsed_page.at_css('#VehicleBasicInformationDescription')&.text&.strip || "Modelo não encontrado"
      price = parsed_page.at_css('#vehicleSendProposalPrice')&.text&.strip || "Preço não encontrado"

      { brand: brand, model: model, price: price }
    end
  end
end
