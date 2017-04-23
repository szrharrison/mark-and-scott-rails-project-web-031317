class Tag < ApplicationRecord
  has_many :picture_tags
  has_many :pictures, -> { distinct }, through: :picture_tags

  validates :name, presence: true

  def self.top_tags
    #set the default value to zero for any new key in this hash
    tag_bins = Hash.new(0)


    # Tag.all.each do |tag|
    #   tag_bins["#{tag.name}"] = 0
    # end

    #TODO refactor using activerecord
    Picture.all.each do |picture|
      picture.tags.each{|tag| tag_bins["#{tag.name}"] += 1}
    end

    tag_bins.sort_by{|k,v| v}.reverse#[0]
  end
end
