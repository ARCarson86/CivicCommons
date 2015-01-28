require 'rails_helper'

RSpec.describe PrivateLabelConstraint do
  let(:namespace) { "private_label_namespace" }
  let(:domain) { "private_label_domain.com" }
  let!(:private_label) { create :private_label, namespace: namespace, domain: domain }
  let(:req) { double("object") }

  describe ".matches?" do
    before(:each) do
      allow(req).to receive(:subdomains) { request_subdomains }
      allow(req).to receive(:host) { request_domain }
    end

    let!(:constraint_value) { PrivateLabelConstraint.matches?(req) }

    describe "with a valid subdomain" do
      let(:request_subdomains) { [ namespace, 'privatelabel'] }
      let(:request_domain) { "example.com" }
      specify { expect(constraint_value).to be_truthy }
      specify { expect(Swayze.current_private_label).to eq(private_label) }
    end

    describe "with a valid domain name" do
      let(:request_subdomains) { [] }
      let(:request_domain) { domain }
      specify { expect(constraint_value).to be_truthy }
      specify { expect(Swayze.current_private_label).to eq(private_label) }
    end

    describe "with a subdomain that doesn't match a private label" do
      let(:request_subdomains) { ['wrong', 'privatelabel'] }
      let(:request_domain) { "example.com" }
      specify { expect(constraint_value).to be_falsey }
      specify { expect(Swayze.current_private_label).to be_falsey }
    end

    describe "with a domain that doesn't match a private label" do
      let(:request_subdomains) { [] }
      let(:request_domain) { "example.com" }
      specify { expect(constraint_value).to be_falsey }
      specify { expect(Swayze.current_private_label).to be_falsey }
    end
    
  end

end
