class Updater
  def self.for(item)
    registry.find {|candidate| candidate.handles?(item)}.new(item)
  end
  
  def self.registry
    @registry ||= []
  end

  def self.register(candidate)
    registry.prepend(candidate)
  end

  # Updater defaults to handling Normal Items
  def self.handles?(item)
    true
  end

  Updater.register(self)

  attr_accessor :item

  def initialize(item)
    @item = item
  end

  def update
    item.sell_in -= 1
    return if item.quality <= 0

    item.quality -= 1
    item.quality -= 1 if item.sell_in <= 0 && item.quality > 1
  end
end
