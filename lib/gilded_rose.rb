class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      Updater.for(item).update
    end
  end
end

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

class BrieUpdater < Updater
  def self.handles?(item)
    item.name == 'Aged Brie'
  end

  Updater.register(self)

  def update
    item.sell_in -= 1
    return if item.quality >= 50

    item.quality += 1
    item.quality += 1 if item.sell_in <= 0 && item.quality < 50
  end
end

class PassUpdater < Updater
  def self.handles?(item)
    # returns `true` for case-insensitive 'backstage pass' substring
    item.name.match?(/backstage pass/i)
  end

  Updater.register(self)

  def update
    item.sell_in -= 1
    return item.quality = 0 if item.sell_in < 0
    return if item.quality >= 50

    item.quality += 1
    item.quality += 1 if item.sell_in < 10 && item.quality < 50
    item.quality += 1 if item.sell_in < 5 && item.quality < 50
  end
end

class SulfurasUpdater < Updater
  def self.handles?(item)
    item.name == 'Sulfuras, Hand of Ragnaros'
  end

  Updater.register(self)

  def update
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
