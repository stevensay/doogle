require 'rails_helper'

describe DoogleController do
  describe "GET index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
  
  describe "POST create" do
    let(:word) { "nba"}
    
    context "word is in database" do
      let(:entry) { create(:entry_with_definitions, word: word) }

      before do
        entry
        post :create, { word: word }
      end

      it "returns a 200"  do
        expect(response).to have_http_status(:ok)
      end
      
      it "returns JSON containing definitions" do
        expect(response.body).to eq(entry.to_json(only: [:word], include: { definitions: { only: :text } }))
      end
    end
    
    context "word is not in database" do
      let(:status) { 200 }
      let(:body) { nil }
  
      before do
        stub_request(:get, /.*dictionaryapi.com\/api\/v1\/references\/collegiate\/xml\/#{word}.*/).
          to_return(:status => status, :body => body)
        
        post :create, { word: word }
      end
  
      context "word with definitions" do
        let(:body) { <<-XML }
          <?xml version="1.0" encoding="utf-8" ?>
          <entry_list version="1.0">
            <entry id="NBA">
              <ew>NBA</ew>
              <subj>SF-1#SM-2</subj>
              <hw>NBA</hw>
              <fl>abbreviation</fl>
              <def>
                <sn>1</sn>
                <dt>National Basketball Association</dt>
                <sn>2</sn>
                <dt>National Boxing Association</dt>
              </def>
            </entry>
          </entry_list>          
        XML
  
        it "returns a 200"  do
          expect(response).to have_http_status(:ok)
        end
        
        it "returns JSON containing definitions" do
          expect(response.body).to eq({
            word: word,
            definitions: [
              { text: "National Basketball Association" },
              { text: "National Boxing Association" }
            ]
          }.to_json)
        end
      end
      
      context "word with no definitions" do
        let(:word) { "uuuxxxx" }
        let(:body) { <<-XML }
          <?xml version="1.0" encoding="utf-8" ?>
          <entry_list version="1.0">
        	</entry_list>
        XML
  
        it "returns a 404" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end