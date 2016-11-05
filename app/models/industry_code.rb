class IndustryCode < ActiveRecord::Base
  has_many :series

  validates :name, presence: true
  validates :internal_name, presence: true
  validates :internal_name, uniqueness: true

  has_many :children, class_name: "IndustryCode", foreign_key: "parent_id"
  belongs_to :parent, class_name: "IndustryCode"

  def display_name
    internal_name == "not_specified" ? nil : name
  end

  def self.not_specified
    @not_specified ||= find_by(internal_name: 'not_specified')
  end

  def all_descendants
    descendant_ids = []
    if children
      descendant_ids << children.ids
      children.each do |child|
        descendant_ids << child.all_descendants
      end
    end
    descendant_ids.flatten.uniq
  end
end