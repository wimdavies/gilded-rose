# frozen_string_literal: true

class PassUpdater
  def handles?(item)
    item.name.start_with?('Backstage pass')
  end

  def update(item)
    item.sell_in -= 1
    return item.quality = 0 if item.sell_in.negative?
    return if item.quality >= 50

    item.quality += 1
    item.quality += 1 if item.sell_in < 10 && item.quality < 50
    item.quality += 1 if item.sell_in < 5 && item.quality < 50
  end
end
