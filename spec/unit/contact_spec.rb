require 'capybara/rspec'

RSpec.describe 'Contact form', type: :feature do
  before do
    visit '/contact'
  end

  it 'submits a valid form' do
    select 'Course suggestion', from: 'reason'
    fill_in 'firstname', with: 'John'
    fill_in 'lastname', with: 'Pork'
    fill_in 'email', with: 'john@example.com'
    fill_in 'message', with: 'Edflix is great!'

    click_button 'Submit'

    expect(page).to have_text('Thank you for your feedback!')
  end
end
