# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Atm, type: :model do
  before :each do
    @bank = FactoryBot.create(:bank)
    @atm = FactoryBot.create(:atm, bank_id: @bank.id)
    @branch = FactoryBot.create(:branch, bank_id: @bank.id)
    @user = FactoryBot.create(:user, branch_id: @branch.id)
    @account = FactoryBot.create(:account, user_id: @user.id)
    @transaction = FactoryBot.build(:transaction, account_id: @account.id)
  end
  context 'atm validation' do
    it 'has valid factory' do
      expect(FactoryBot.create(:atm, bank_id: @bank.id)).to be_valid
    end
    it 'is invalid without a name' do
      expect(FactoryBot.build(:atm, name: nil, bank_id: @bank.id)).not_to be_valid
    end
    it 'is invalid without address' do
      expect(FactoryBot.build(:atm, address: nil, bank_id: @bank.id)).not_to be_valid
    end
    it 'is invalid without bank' do
      expect(FactoryBot.build(:atm, bank_id: nil)).to be_invalid
    end
  end
  context 'atm associations' do
    it 'has many transactions' do
      @atm = FactoryBot.create(:atm, bank_id: @bank.id)
      @t = FactoryBot.create(:transaction, account_id: @account.id, atm_id: @atm.id)
      @t2 = FactoryBot.create(:transaction, account_id: @account.id, atm_id: @atm.id)
      expect(@atm.transactions).to include(@t)
      expect(@atm.transactions).to include(@t2)
    end
    it 'has not unincluded tarnsactions' do
      @atm1 = FactoryBot.create(:atm, bank_id: @bank.id)
      @atm2 = FactoryBot.create(:atm, bank_id: @bank.id)
      @t1 = FactoryBot.create(:transaction, account_id: @account.id, atm_id: @atm1.id)
      @t2 = FactoryBot.create(:transaction, account_id: @account.id, atm_id: @atm2.id)
      expect(@atm1.transactions).to include(@t1)
      expect(@atm1.transactions).not_to include(@t2)
      expect(@atm2.transactions).to include(@t2)
      expect(@atm2.transactions).not_to include(@t1)
    end
    it 'has belongs to bank' do
      @a = FactoryBot.create(:atm, bank_id: @bank.id)
      expect(@a.bank.id).to eq(@bank.id)
    end
    it 'is not belongs to invalid bank' do
      @b1 = FactoryBot.create(:bank)
      @b2 = FactoryBot.create(:bank)
      @a1 = FactoryBot.create(:atm, bank_id: @b1.id)
      expect(@a1.bank.id).to eq(@b1.id)
      expect(@a1.bank.id).not_to eq(@b2.id)
    end
  end
end
