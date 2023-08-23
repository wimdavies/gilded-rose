# frozen_string_literal: true

require_relative 'item'
require_relative 'normal_updater'
require_relative 'brie_updater'
require_relative 'pass_updater'
require_relative 'sulfuras_updater'
require_relative 'conjured_updater'

DEFAULT_UPDATERS = [
  ConjuredUpdater.new,
  BrieUpdater.new,
  PassUpdater.new,
  SulfurasUpdater.new,
  NormalUpdater.new
].freeze

class GildedRose
  def initialize(items, updaters = DEFAULT_UPDATERS)
    @items = items
    @updaters = updaters
  end

  def update_quality
    @items.each do |item|
      find_updater_for(item).update(item)
    end
  end

  private

  def find_updater_for(item)
    @updaters.find { |updater| updater.handles?(item) }
  end
end
