require 'spec_helper'


describe MemberExportService do

  before(:each) do
    @time1 = DateTime.parse('1 june, 2012, 1pm')
    @time2 = DateTime.parse('2 june, 2012, 1pm')
    @person = FactoryGirl.create(:registered_user, :email => 'johnd@test.com', :website => 'http://example.com', :created_at => @time1, :confirmed_at => @time2, :id => 123)
  end
  describe "export_to_csv" do
    it "should export to csv" do
      MemberExportService.export_to_csv.should == "ID,Type,Name,Email,Website,Zip Code,Registered,Confirmed,Admin,Proxy,Locked\n123,Person,John Doe,johnd@test.com,http://example.com,44313,2012.06.01,2012.06.02,no,no,no\n"
    end
    it "should contain ID column" do
      MemberExportService.export_to_csv.should =~ /ID/
      MemberExportService.export_to_csv.should =~ /123/
    end
    it "should contain Type column" do
      MemberExportService.export_to_csv.should =~ /Type/
      MemberExportService.export_to_csv.should =~ /Person/
    end
    it "should contain Name column" do
      MemberExportService.export_to_csv.should =~ /Name/
      MemberExportService.export_to_csv.should =~ /John Doe/
    end
    it "should contain Email column" do
      MemberExportService.export_to_csv.should =~ /Email/
      MemberExportService.export_to_csv.should =~ /johnd@test.com/
    end
    it "should contain Website column" do
      MemberExportService.export_to_csv.should =~ /Website/
      MemberExportService.export_to_csv.should =~ /http:\/\/example\.com/
    end
    it "should contain Zip Code column" do
      MemberExportService.export_to_csv.should =~ /Zip Code/
      MemberExportService.export_to_csv.should =~ /44313/
    end
    it "should contain Registered column" do
      MemberExportService.export_to_csv.should =~ /Registered/
      MemberExportService.export_to_csv.should =~ /2012.06.01/
    end
    it "should contain Confirmed column" do
      MemberExportService.export_to_csv.should =~ /Confirmed/
      MemberExportService.export_to_csv.should =~ /2012.06.02/
    end
    it "should contain Admin column" do
      @person.update_attribute(:admin, true)
      MemberExportService.export_to_csv.should =~ /Admin/
      MemberExportService.export_to_csv.should =~ /yes/
    end
    it "should contain Proxy column" do
      @person.update_attribute(:proxy, true)
      MemberExportService.export_to_csv.should =~ /Proxy/
      MemberExportService.export_to_csv.should =~ /yes/
    end
    it "should contain Locked column" do
      @person.update_attribute(:locked_at, @time2)
      MemberExportService.export_to_csv.should =~ /Locked/
      MemberExportService.export_to_csv.should =~ /yes/
    end
    

    
  end
end
