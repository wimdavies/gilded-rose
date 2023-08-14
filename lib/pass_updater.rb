require_relative 'updater'

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
