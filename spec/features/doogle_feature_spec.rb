require 'rails_helper'

feature 'Word search', js:true do
  let(:valid_word) { "nba" }
  let(:invalid_word) { "xyz" }
  
  scenario "User searches for words" do
    visit root_path
    expect(page).to have_content 'Doogle'
    expect(page).to have_button 'Doogle Search'

    # search for word that does not exist in local database but exists in dictionary api
    
    # mock response from dictionary api to return definitions
    stub_request(:get, /.*dictionaryapi.com\/api\/v1\/references\/collegiate\/xml\/#{valid_word}.*/).
      to_return(:status => 200, :body => <<-XML)
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
    
    fill_in 'word-input', with: valid_word
    click_button 'Doogle Search'
    
    expect(page).to_not have_selector ".has-error"
    expect(page).to have_selector ".definition-item", count: 2
    expect(page).to have_content 'National Basketball Association'
    expect(page).to have_content 'National Boxing Association'

    WebMock.reset!

    # seach for invalid word
    
    # mock response from dictionary api to return empty definitions
    stub_request(:get, /.*dictionaryapi.com\/api\/v1\/references\/collegiate\/xml\/#{invalid_word}.*/).
      to_return(:status => 200, :body => <<-XML)
        <?xml version="1.0" encoding="utf-8" ?>
        <entry_list version="1.0">
        </entry_list>
      XML

    fill_in "word-input", with: invalid_word
    click_button 'Doogle Search'
    
    expect(page).to have_selector ".has-error"
    expect(page).to_not have_selector ".definition-item"

    WebMock.reset!

    # search for word again which should now exists in local database
    
    fill_in "word-input", with: valid_word
    click_button 'Doogle Search'
    
    expect(page).to_not have_selector ".has-error"
    expect(page).to have_selector ".definition-item", count: 2
    expect(page).to have_content 'National Basketball Association'
    expect(page).to have_content 'National Boxing Association'
  end
end