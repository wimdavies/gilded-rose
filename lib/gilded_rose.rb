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
    case item.name
    when 'Aged Brie'
      BrieUpdater
    when /backstage pass/i
      PassUpdater
    when 'Sulfuras, Hand of Ragnaros'
      SulfurasUpdater
    else
      NormalUpdater
    end.new(item)
  end

  attr_accessor :item

  def initialize(item)
    @item = item
  end

  def update
  end

  def decrement_sell_in
    item.sell_in -= 1
  end

  def decrement_quality
    item.quality -= 1
  end

  def increment_quality
    item.quality += 1
  end
end

class NormalUpdater < Updater
  def update
    decrement_sell_in
    return if item.quality <= 0

    decrement_quality
    decrement_quality if item.sell_in <= 0 && item.quality > 1
  end
end

class BrieUpdater < Updater
  def update
    decrement_sell_in
    return if item.quality >= 50

    increment_quality
    increment_quality if item.sell_in <= 0 && item.quality < 50
  end
end

class PassUpdater < Updater
  def update
    decrement_sell_in
    return item.quality = 0 if item.sell_in < 0
    return if item.quality >= 50

    increment_quality
    increment_quality if item.sell_in < 10 && item.quality < 50
    increment_quality if item.sell_in < 5 && item.quality < 50
  end
end

class SulfurasUpdater < Updater
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
