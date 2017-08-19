class Currency < ApplicationRecord
  validates :name, uniqueness: { message:'重複的幣種'}
  validates :name, presence: { message: '欄位不可空白'}
end
