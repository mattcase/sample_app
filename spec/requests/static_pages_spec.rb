require 'spec_helper'

describe "Static pages" do

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About Us')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up')
    click_link "sample app"
    page.should have_selector 'title', text: full_title('')
  end

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Home' }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem")
        FactoryGirl.create(:micropost, user: user, content: "Ipsum")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "stats for one follower" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end

      describe "stats for two followers" do
        let(:other_user1) { FactoryGirl.create(:user) }
        let(:other_user2) { FactoryGirl.create(:user) }
        before do
          other_user1.follow!(user)
          other_user2.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("2 followers", href: followers_user_path(user)) }
      end

      describe "stats for following one" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          user.follow!(other_user)
          visit root_path
        end

        it { should have_link("1 following", href: following_user_path(user)) }
        it { should have_link("0 followers", href: followers_user_path(user)) }
      end


      describe "stats for following two" do
        let(:other_user1) { FactoryGirl.create(:user) }
        let(:other_user2) { FactoryGirl.create(:user) }
        before do
          user.follow!(other_user1)
          user.follow!(other_user2)
          visit root_path
        end

        it { should have_link("2 following", href: following_user_path(user)) }
        it { should have_link("0 followers", href: followers_user_path(user)) }
      end

      describe "sidebar with two microposts" do
        before do
          FactoryGirl.create(:micropost, user: user1, content: "Lorem")
          FactoryGirl.create(:micropost, user: user1, content: "Ipsum")
          sign_in user1
          visit root_path
          it { should have_content('microposts') }
          it { should_not have_content('micropost ') }
        end
      end

      describe "sidebar with one micropost" do
        before do
          FactoryGirl.create(:micropost, user: user2, content: "Lorem")
          sign_in user2
          visit root_path
          it { should have_content('micropost ') }
          it { should_not have_content('microposts') }
        end
      end
    end
  end


  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should have_selector 'title', text: '| Help' }
  end
  
  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About Us' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should have_selector 'title', text: '| About Us' }
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should have_selector 'title', text: '| Contact' }
  end
end