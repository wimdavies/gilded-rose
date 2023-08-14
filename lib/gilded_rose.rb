# frozen_string_literal: true

require_relative 'item'
require_relative 'updater'
require_relative 'brie_updater'
require_relative 'pass_updater'
require_relative 'sulfuras_updater'
require_relative 'conjured_updater'

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      Updater.for(item).update
    end
  end
end
