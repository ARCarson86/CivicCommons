require File.dirname(__FILE__) + '/../spec_helper'

[Contribution, Issue, Conversation].each do |model_type|
  describe model_type, "Should have the required columns for Visitable" do
    it "has total_visits" do
      model_type.column_names.should include 'total_visits'
      model_type.columns.find{|c| c.name == 'total_visits'}.type.should == :integer
    end
    it "has last_visit_date" do
      model_type.column_names.should include 'last_visit_date'
      model_type.columns.find{|c| c.name == 'last_visit_date'}.type.should == :datetime
    end
    it "has_recent_visits" do
      model_type.column_names.should include 'recent_visits'
      model_type.columns.find{|c| c.name == 'recent_visits'}.type.should == :integer
    end
  end
  describe model_type, "When working with visits" do
    before(:each) do
      @person = FactoryGirl.create(:normal_person)
      @item = FactoryGirl.create(model_type.to_s.downcase, {:total_visits=>0, :recent_visits=>0, :last_visit_date=>nil})
    end
    context "and visiting a #{model_type.to_s}" do
       it "adds a visit to the #{model_type.to_s}" do      
         @item.visit(@person.id)
       
         @item.visits.count.should == 1
         @item.visits[0].person.should == @person      
       end
       it "modifies the total_visits for the #{model_type.to_s}" do
         @item.visit(@person.id)
       
         @item.total_visits.should == 1
       end
       it "modifies the recent_visits for the #{model_type.to_s}" do
         @item.visit(@person.id)
       
         @item.recent_visits.should == 1
       end
       it "updates the last visited date" do
         current_time = Time.now
         Time.stub(:now).and_return(current_time)
  
         @item.visit(@person.id)
       
         @item.last_visit_date.should == current_time
       end
       context "and the non-persisance visit method is called" do    
         it "should not persist the new visit" do
           @item.visit(@person.id)

           new_item = model_type.find(@item.id)

           new_item.total_visits.should == 0         
         end      
       end
       context "and the persist visit method is called" do
          it "should persist the new visit" do
            @item.visit!(@person.id)

            new_item = model_type.find(@item.id)

            new_item.total_visits.should == 1         
          end
       end
    end
    context "and calculating the recent visits" do
      it "should count visits in the last 30 days" do
        @item.visits << Visit.create({:person_id=>@person.id, :created_at=>(Time.now - 60.days)})
        @item.visits << Visit.create({:person_id=>@person.id, :created_at=>(Time.now - 29.days)})
        @item.visits << Visit.create({:person_id=>@person.id, :created_at=>Time.now})
      
        @item.calculate_recent_visits.should == 2
      end
    end
    context "and identifying the top visited items" do  
      it "should order by recent_visits" do
        @item_10 = FactoryGirl.create(model_type.to_s.downcase, {:total_visits=>10, :recent_visits=>10, :last_visit_date=>Time.now})
        @item_5 = FactoryGirl.create(model_type.to_s.downcase, {:total_visits=>5, :recent_visits=>5, :last_visit_date=>Time.now})      
        @item_1 = FactoryGirl.create(model_type.to_s.downcase, {:total_visits=>1, :recent_visits=>1, :last_visit_date=>Time.now})            

        result = model_type.get_top_visited
    
        result[0].should == @item_10
        result[1].should == @item_5
        result[2].should == @item_1
      end
      it "should not include records if last visit is older than 30 days" do
        @item_old = FactoryGirl.create(model_type.to_s.downcase, {:total_visits=>10, :recent_visits=>10, :last_visit_date=>(Time.now - 60.days)})

        result = model_type.get_top_visited

        result.include?(@item_old).should == false
      end      
    end
  end
end
