class TagDef < ActiveRecord::Base
  attr_accessible :entity_class, :tag, :meaning

  validates :entity_class, :presence => true, :length => { :maximum => 32 }
  validates :tag, :presence => true, :length => { :maximum => 32 }
  validates :meaning, :presence => true

  def tags
    Tag.find_all_by_entity_class_and_tag(self.entity_class, self.tag)
  end

  def targets
    self.tags.collect { |t| t.target }
  end

  def tag!(target_id)
    Tag.create!(entity_class: self.entity_class, tag: self.tag, target_id: target_id)
  end

  def untag!(target_id)
    Tag.where(entity_class: self.entity_class, tag: self.tag, target_id: target_id).destroy_all
  end

end
