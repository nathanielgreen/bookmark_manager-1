require_relative '../factories/user'


feature 'User sign-up' do

  scenario 'I can sign up as a new user' do
    user = build :user
    expect{sign_up_as(user)}.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, alice@example.com')
    expect(User.first.email).to eq('alice@example.com')
  end

  def sign_up_as(user)
    visit '/users/new'
    expect(page.status_code).to eq(200)
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    fill_in :password_confirmation, with: user.password_confirmation
    click_button 'Sign up'
  end

  scenario 'with a password that does not match' do
    user = build :user, password_confirmation: 'wrong'
    expect { sign_up_as(user) }.not_to change(User, :count)
    expect(current_path).to eq '/users'
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario 'user can\'t sign up without entering an email' do
    user = build :user, email: nil
    expect { sign_up_as(user) }.not_to change(User, :count)
  end

  scenario 'I cannot sign up with an existing email' do
    user = build :user
    sign_up_as(user)
    expect{sign_up_as(user)}.to change(User, :count).by(0)
    expect(page).to have_content 'Email is already taken'
  end

end

feature 'User can sign in' do

  let(:user) do
    create :user
    # User.create(email: 'alice@example.com',
    #             password: 'oranges'
    #             password_confirmation: 'oranges')
  end

  scenario 'with correct credentials' do
    sign_in_as(user)
    expect(page).to have_content "Welcome, #{user.email}"
  end

  def sign_in_as(user)
    visit '/sessions/new'
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Sign in'
  end


end
