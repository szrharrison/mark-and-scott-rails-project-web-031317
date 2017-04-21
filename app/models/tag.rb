class Tag < ApplicationRecord
  has_many :picture_tags
  has_many :pictures, -> { distinct }, through: :picture_tags

  validates :name, presence: true

  def self.top_tags
    tag_bins = {}
    Tag.all.each do |tag|
      tag_bins["#{tag.name}"] = 0
    end

    Picture.all.each do |picture|
      picture.tags.each{|tag| tag_bins["#{tag.name}"] += 1}
    end
    puts tag_bins
  end
end
