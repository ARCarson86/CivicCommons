#failure goto_admin_page_as_admin
require 'acceptance/acceptance_helper'

feature "Admin RadioShow Index", %q{
  As an admin
  When I want the description of all radio shows to be changed
  I will be able to edit - change or delete this text in my admin pages
} do
  background do
    goto_admin_page_as_admin
    follow_radio_shows_link
  end

  scenario "Add new short/long descriptions for RadioShows" do
    database.should_not have_any_radio_show_descriptions
    fill_in_radio_show_descriptions_with defaults
    click_update_radioshow_descriptions_button
    database.should have_any_radio_show_descriptions
  end

  scenario "Edit short/long descriptions for RadioShows" do
    fill_in_radio_show_descriptions_with :description_short => 'shorter', :description_long => 'longer'
    click_update_radioshow_descriptions_button
    radio_show_description = database.latest_radio_show_description
    radio_show_description.description_long.should == 'longer'
    radio_show_description.description_short.should == 'shorter'
  end
end