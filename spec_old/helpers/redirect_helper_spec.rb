require 'spec_helper'

describe RedirectHelper do
  it 'will not allow redirects to nil' do
    RedirectHelper.valid?(nil).should be_false
  end

  it 'will not allow redirects to Devise routes' do
    RedirectHelper.valid?('people/login').should be_false
    RedirectHelper.valid?('people/logout').should be_false
    RedirectHelper.valid?('people/secret').should be_false
    RedirectHelper.valid?('people/verification').should be_false
    RedirectHelper.valid?('people/register').should be_false
    RedirectHelper.valid?('people/new').should be_false
  end

  it 'will allow redirects to non-Devise routes' do
    RedirectHelper.valid?('about').should be_true
    RedirectHelper.valid?('in-the-news').should be_true
    RedirectHelper.valid?('community').should be_true
  end
end