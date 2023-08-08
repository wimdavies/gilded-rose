class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      case item.name
      when 'Aged Brie'
        aged_brie_update_quality(item)
      when 'Backstage passes to a TAFKAL80ETC concert'
        backstage_pass_update_quality(item)
      when 'Sulfuras, Hand of Ragnaros'
        sulfuras_update_quality(item)
      else
        normal_update_quality(item)
      end
    end
  end

  def normal_update_quality(item)
    item.sell_in -= 1
    return if item.quality <= 0

    item.quality -= 1
    item.quality -= 1 if item.sell_in <= 0 && item.quality > 1
  end

  def aged_brie_update_quality(item)
    item.sell_in -= 1
    return if item.quality >= 50

    item.quality += 1
    item.quality += 1 if item.sell_in <= 0 && item.quality < 50
  end

  def backstage_pass_update_quality(item)
    item.sell_in -= 1
    return item.quality = 0 if item.sell_in < 0
    return if item.quality >= 50

    item.quality += 1
    item.quality += 1 if item.sell_in < 10
    item.quality += 1 if item.sell_in < 5
  end

  def sulfuras_update_quality(item)
    return
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
