# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tool, type: :model do
  describe '.enabled' do
    let!(:tool) { create(:tool, :accepted) }
    let!(:tool_disabled) { create(:tool, :pending) }

    it 'returns enabled records' do
      scoped_records = Tool.enabled
      expect(scoped_records.length).to eq 1
      expect(scoped_records).to include tool
    end
  end
end
