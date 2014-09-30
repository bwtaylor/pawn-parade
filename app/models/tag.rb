class Tag < ActiveRecord::Base
  attr_accessible :entity_class, :tag, :target_id

  validates :entity_class, :presence => true, :length => { :maximum => 32 }
  validates :tag, :presence => true, :length => { :maximum => 32 }
  validates :target_id, :presence => true

  def meaning
    TagDef.find_by_entity_class_and_tag(self.entity_class, self.tag)
  end

  def target
    self.entity_class.constantize.find(target_id)
  end

end
