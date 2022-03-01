# frozen_string_literal: true

require 'spec_helper'

RSpec.describe VatInfo::Models::VatPayer do
  describe '.new' do
    it 'creates VatPayer hash in correct structure' do
      params = VCR.use_cassette('vat_payer_data') do
        response = VatInfo.unreliable_payer('CZ26168685')
        response.raw
      end[:status_nespolehlivy_platce_response][:status_platce_dph]

      vat_payer = VatInfo::Models::VatPayer.new(params).data
      expect(vat_payer[:cislo_fu]).to eq '13'
      expect(vat_payer[:nespolehlivy_platce]).to eq 'NE'
      expect(vat_payer[:dic]).to eq 'CZ26168685'
      expect(vat_payer[:ucty].size).to eq 8
    end

    it 'raises InvalidStructure exception if input does not contain mandatory data' do
      expect { VatInfo::Models::VatPayer.new(a: 1) }.to raise_error(VatInfo::Models::InvalidStructure)
    end
  end
end
