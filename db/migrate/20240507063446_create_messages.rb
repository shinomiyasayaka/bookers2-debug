class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.text :message

      t.timestamps
    end
  end
end

#references 作成済みのテーブルを指定する場合に使う
