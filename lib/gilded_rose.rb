class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      return if item.name == 'Sulfuras, Hand of Ragnaros'

      if item.name != "Aged Brie" and item.name != "Backstage passes to a TAFKAL80ETC concert"
        decrement_quality_if_greater_than_zero(item)
      else
        if item.quality < 50
          item.quality = item.quality + 1
          if item.name == "Backstage passes to a TAFKAL80ETC concert"
            if item.sell_in < 11
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
            if item.sell_in < 6
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
          end
        end
      end

      decrement_sell_in(item)

      if item.sell_in < 0
        if item.name != "Aged Brie"
          if item.name != "Backstage passes to a TAFKAL80ETC concert"
            decrement_quality_if_greater_than_zero(item)
          else
            item.quality = item.quality - item.quality
          end
        else
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
      end
    end
  end

  def decrement_sell_in(item)
    item.sell_in = item.sell_in - 1
  end

  def decrement_quality_if_greater_than_zero(item)
    if item.quality > 0
      item.quality = item.quality - 1
    end
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
