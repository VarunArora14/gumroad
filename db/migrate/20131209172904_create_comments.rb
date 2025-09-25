# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true
      t.references :author
      t.string :author_name
      t.text :content
      t.text :json_data
      t.timestamps
      t.datetime :deleted_at
      t.references :purchase
      t.string :ancestry
      t.integer :ancestry_depth, default: 0, null: false
    end
    add_index(:comments, [:commentable_id, :commentable_type])
  end
end
