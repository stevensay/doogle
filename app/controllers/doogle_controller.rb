class DoogleController < ApplicationController
  API_URL = "http://www.dictionaryapi.com/api/v1/references/collegiate/xml"
  API_KEY = "cab72891-f003-43ef-a983-253666d45082"
  
  def index
  end
  
  def create
    entry = find_definitions_in_database || find_definitions_using_dictionary

    if entry.present?
      render json: entry.to_json(only: [:word], include: { definitions: { only: [:text] } })
    else
      head :not_found
    end
  end
  
  private
  
  def find_definitions_in_database
    Entry.find_by word: params[:word]
  end
  
  def find_definitions_using_dictionary
    response = Faraday.get "#{API_URL}/#{params[:word]}?key=#{API_KEY}"
    
    if response.success?
      doc = Nokogiri::XML(response.body)
      definitions = doc.xpath("//def/dt").map { |d| d.text.sub!(/^[\: ]*/, "") }
      
      unless definitions.empty?
        entry = Entry.create(word: params[:word])
        definitions.each do |definition|
          Definition.create(text: definition, entry: entry)
        end
        entry
      end
    end
  end
end