require 'gilded_rose'

RSpec.describe GildedRose do
  describe '#update_quality' do
    it 'does not change the item name' do
      items = [Item.new("Cloak", 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].name).to eq "Cloak"
    end

    context 'Normal Item' do
      it 'decrements both sell_in and quality on every tick' do
        items = [Item.new("Dagger", 47, 47)]
        gilded_rose = GildedRose.new(items)
        4.times { gilded_rose.update_quality } 
        expect(items[0].sell_in).to eq 43
        expect(items[0].quality).to eq 43
      end

      it 'decreases quality at 2x rate when sell_in is less than 0' do
        items = [Item.new("Dagger", 0, 10)]
        gilded_rose = GildedRose.new(items)
        4.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 2
      end

      it 'never decreases quality below 0' do
        items = [Item.new("Dagger", 47, 43)]
        gilded_rose = GildedRose.new(items)
        500.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 0
      end
    end
  end
end
