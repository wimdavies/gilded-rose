# frozen_string_literal: true

class SulfurasUpdater
  def handles?(item)
    item.name == 'Sulfuras, Hand of Ragnaros'
  end

  def update(item); end
end
