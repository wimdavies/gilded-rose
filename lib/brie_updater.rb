# frozen_string_literal: true

require_relative 'updater'

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
