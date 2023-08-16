# frozen_string_literal: true

require_relative 'updater'

class PassUpdater < Updater
  def self.handles?(item)
    item.name.start_with?('Backstage pass')
  end

  Updater.register(self)

  def update
    item.sell_in -= 1
    return item.quality = 0 if item.sell_in.negative?
    return if item.quality >= 50

    item.quality += 1
    item.quality += 1 if item.sell_in < 10 && item.quality < 50
    item.quality += 1 if item.sell_in < 5 && item.quality < 50
  end
end
