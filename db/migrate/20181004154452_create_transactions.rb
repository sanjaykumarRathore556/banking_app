# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :amount
      t.string :transaction_type
      t.references :account, index: true, foreign_key: true
      t.references :atm, index: true, foreign_key: true
      t.timestamps
    end
  end
end
