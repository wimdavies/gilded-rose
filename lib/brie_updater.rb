# frozen_string_literal: true

class BrieUpdater
  def handles?(item)
    item.name == 'Aged Brie'
  end

  def update(item)
    item.sell_in -= 1
    return if item.quality >= 50

    item.quality += 1
    item.quality += 1 if item.sell_in <= 0 && item.quality < 50
  end
end
