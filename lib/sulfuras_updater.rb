require_relative 'updater'

class SulfurasUpdater < Updater
  def self.handles?(item)
    item.name == 'Sulfuras, Hand of Ragnaros'
  end

  Updater.register(self)

  def update
  end
end
