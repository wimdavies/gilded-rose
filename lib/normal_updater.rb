# frozen_string_literal: true

class NormalUpdater
  def handles?(item)
    true
  end

  def update(item)
    item.sell_in -= 1
    return if item.quality <= 0

    item.quality -= 1
    item.quality -= 1 if item.sell_in <= 0 && item.quality > 0
  end
end
