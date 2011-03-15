ActiveRecord::Base.establish_connection({
  :database => ":memory:",
  :adapter => 'sqlite3',
  :timeout => 500
})

ActiveRecord::Schema.define do
  create_table :posts, :force => true do |t|
    t.string :title
    t.text :body
  end
end

