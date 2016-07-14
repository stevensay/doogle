FactoryGirl.define do
  factory :entry do
    word "MyString"
    
    factory :entry_with_definitions do
      transient do
        definitions_count 5
      end
      
      after(:create) do |entry, evaluator|
        create_list(:definition, evaluator.definitions_count, entry: entry)
      end
    end
  end
end
