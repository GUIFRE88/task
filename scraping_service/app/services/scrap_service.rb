# frozen_string_literal: true

require 'nokogiri'
require 'httparty'

class ScrapService


  def scrape(url)
    headers = {
      "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }
  
    response = HTTParty.get(url, headers: headers)
  
    if response.code == 200
      sleep(5)  # Atraso para permitir que o JavaScript carregue (ajuste o tempo conforme necessário)
  
      page = Nokogiri::HTML(response)
      brand = page.at_css('.sc-csjSMh.brVEZY .sc-bwCtUz.gqfNBP')&.text&.strip || "Marca não encontrada"
      model = page.at_css('.sc-fFeiMQ.gqRUjg')&.text&.strip || "Modelo não encontrado"
      price = page.at_css('#vehicleSendProposalPrice')&.text&.strip || "Preço não encontrado"
  
      { brand: brand, model: model, price: price }
    else
      raise "Failed to retrieve the webpage. Status code: #{response.code}"
    end
  end
end
