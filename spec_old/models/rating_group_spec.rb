#passed
require 'spec_helper'

describe RatingGroup do

  describe "toggle rating methods" do
    before(:each) do
      @current_person = FactoryGirl.create(:normal_person)
      @contribution = FactoryGirl.create(:contribution)
      @descriptor = FactoryGirl.create(:rating_descriptor)
      @descriptor2 = FactoryGirl.create(:rating_descriptor, :title => "Motivating")
    end

    def add_rating(descriptor = @descriptor)
      RatingGroup.add_rating!(@current_person, @contribution, descriptor)
      find_rgs
    end
    def find_rgs
      @rgs = RatingGroup.find_all_by_contribution_id_and_person_id(@contribution.id, @current_person.id)
    end

    context "add_rating!" do

      it "adds rating group if none exists for contribution/person combination" do
        add_rating
        @rgs.size.should == 1
      end

      it "adds rating for contribution/person" do
        add_rating
        rg = @rgs.first
        rg.ratings.size.should == 1
        rg.ratings.first.rating_descriptor.should == @descriptor
      end

      it "does not add a second rating group if it already exists and second rating is added" do
        add_rating
        RatingGroup.add_rating!(@current_person, @contribution, @descriptor2)
        find_rgs
        @rgs.size.should == 1
        @rgs.first.ratings.size.should == 2
      end

      it "does not allow a user to rate their own contribution" do
        user_contribution = FactoryGirl.create(:contribution, :person => @current_person)
        rg = RatingGroup.add_rating!(@current_person, user_contribution, @descriptor)
        rg.should have_validation_error(:person, /cannot rate own/)
      end
    end

    context "remove_rating!" do

      def remove_rating
        RatingGroup.remove_rating!(@current_person, @contribution, @descriptor)
        find_rgs
      end

      it "removes rating for contribution/person" do
        add_rating
        rgs_id = @rgs.first.id
        remove_rating
        Rating.find_all_by_rating_group_id(rgs_id).should be_empty
      end

      it "removes rating group if last rating for that rating group is deleted" do
        add_rating
        remove_rating
        @rgs.should be_empty
      end

      it "does not remove rating group if any other ratings are still left" do
        add_rating
        add_rating(@descriptor2)
        remove_rating
        @rgs.size.should == 1
        rg = @rgs.first
        rg.ratings.size.should == 1
        rg.ratings.first.rating_descriptor.should == @descriptor2
      end

      it "throws an error if removing a rating that doesn't exist is attempted" do
        add_rating
        lambda {
          RatingGroup.remove_rating!(@current_person, @contribution, @descriptor2)
        }.should raise_error
      end
    end

    context "toggle_rating!" do

      def toggle_rating
        RatingGroup.toggle_rating!(@current_person, @contribution, @descriptor)
      end

      it "adds rating if it does not already exist" do
        add_rating(@descriptor2)
        RatingGroup.should_receive(:add_rating!).with(@current_person, @contribution, @descriptor)
        toggle_rating
      end

      it "removes rating if it already exists" do
        RatingGroup.should_receive(:remove_rating!).with(@current_person, @contribution, @descriptor)
        add_rating
        toggle_rating
      end
    end
  end
  describe "rating finders" do
    before(:each) do
      @current_person = FactoryGirl.create(:normal_person)
      @conversation = FactoryGirl.create(:conversation)
      @contribution = FactoryGirl.create(:comment, :conversation => @conversation)
      @descriptor = FactoryGirl.create(:rating_descriptor)
      @descriptor2 = FactoryGirl.create(:rating_descriptor, :title => "Motivating")
      @descriptor3 = FactoryGirl.create(:rating_descriptor, :title => "Tasty")
      @descriptor4 = FactoryGirl.create(:rating_descriptor, :title => "Sad")
      @rg = FactoryGirl.create(:rating_group, :contribution => @contribution, :person => @current_person)
      @rg2 = FactoryGirl.create(:rating_group, :contribution => @contribution)
      @rating1a = FactoryGirl.create(:rating, :rating_group => @rg, :rating_descriptor => @descriptor)
      @rating1b = FactoryGirl.create(:rating, :rating_group => @rg, :rating_descriptor => @descriptor2)
      @rating2a = FactoryGirl.create(:rating, :rating_group => @rg2, :rating_descriptor => @descriptor)
      @rating2c = FactoryGirl.create(:rating, :rating_group => @rg2, :rating_descriptor => @descriptor3)
      RatingGroup.refresh_cached_rating_descriptors
    end

    it "returns all of the ratings for a conversation" do
      expected_result = {
                          @descriptor.title => [@rating1a, @rating2a],
                          @descriptor2.title => [@rating1b],
                          @descriptor3.title => [@rating2c],
                          @descriptor4.title => []
                        }
      rgs = RatingGroup.ratings_for_conversation(@conversation)
      rgs.should == expected_result
    end

    it "returns all of the ratings for a conversation with counts" do
      expected_result = {
                          @descriptor.title => 2,
                          @descriptor2.title => 1,
                          @descriptor3.title => 1,
                          @descriptor4.title => 0
                        }
      rgs = RatingGroup.ratings_for_conversation_with_count(@conversation)
      rgs.should == expected_result
    end

    it "returns all of the ratings for a conversation by contribution with counts" do
      expected_result = {
        @contribution.id => {
          @descriptor.title => {:total => 2, :person => nil},
          @descriptor2.title => {:total => 1, :person => nil},
          @descriptor3.title => {:total => 1, :person => nil},
          @descriptor4.title => {:total => 0, :person => nil}
        }
      }
      rgs = RatingGroup.ratings_for_conversation_by_contribution_with_count(@conversation)
      rgs.should == expected_result
    end

    it "returns all ratings for contributions in convo with counts for person if person given" do
      expected_result = {
        @contribution.id => {
          @descriptor.title => {:total => 2, :person => true},
          @descriptor2.title => {:total => 1, :person => true},
          @descriptor3.title => {:total => 1, :person => false},
          @descriptor4.title => {:total => 0, :person => false}
        }
      }

      rgs = RatingGroup.ratings_for_conversation_by_contribution_with_count(@conversation, @current_person)
      rgs.should == expected_result
    end

    it "returns a hash of ids/titles of all rating descriptors" do
      expected_result = {
        @descriptor.id  => @descriptor.title,
        @descriptor2.id => @descriptor2.title,
        @descriptor3.id => @descriptor3.title,
        @descriptor4.id => @descriptor4.title
      }

      RatingGroup.rating_descriptors.should == expected_result
    end

    it "returns a hash of ids/titles of all cached rating descriptors" do
      expected_result = {
        @descriptor.id  => @descriptor.title,
        @descriptor2.id => @descriptor2.title,
        @descriptor3.id => @descriptor3.title,
        @descriptor4.id => @descriptor4.title
      }

      RatingGroup.cached_rating_descriptors.should == expected_result
      RatingGroup.cached_rating_descriptors.should == expected_result
    end

    it "returns skeleton of expected hash for contribution with not rating_groups" do
      contribution = FactoryGirl.build(:contribution, :id => 42)
      ratings = RatingGroup.ratings_for_conversation_by_contribution_with_count(@conversation, @current_person)

      expected_result = {
        @descriptor.title => {:total => 0, :person => false},
        @descriptor2.title => {:total => 0, :person => false},
        @descriptor3.title => {:total => 0, :person => false},
        @descriptor4.title => {:total => 0, :person => false}
      }

      ratings[contribution.id].should == expected_result
    end

    it "returns a sentance for listing all assigned rating titles" do
      @rg.ratings_titles.should == 'Inspiring and Motivating'
    end
  end
end
