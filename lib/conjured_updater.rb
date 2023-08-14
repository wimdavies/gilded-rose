# frozen_string_literal: true

require_relative 'updater'

class ConjuredUpdater < Updater
  def self.handles?(item)
    item.name.start_with?('Conjured')
  end

  Updater.register(self)

  def update
    item.sell_in -= 1
    return if item.quality <= 0

    item.quality -= 1
    item.quality -= 1 if item.quality > 0
    item.quality -= 1 if item.sell_in <= 0 && item.quality > 0
    item.quality -= 1 if item.sell_in <= 0 && item.quality > 0
  end
end
