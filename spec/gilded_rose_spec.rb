require 'gilded_rose'

RSpec.describe GildedRose do
  describe '#update_quality' do
    it 'does not change the item name' do
      items = [Item.new('Cloak', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].name).to eq 'Cloak'
    end

    context 'Normal Item' do
      it 'decrements sell_in on every tick' do
        items = [Item.new('Dagger', 47, 47)]
        gilded_rose = GildedRose.new(items)
        4.times { gilded_rose.update_quality } 
        expect(items[0].sell_in).to eq 43
      end

      it 'decrements sell_in below 0' do
        items = [Item.new('Dagger', 0, 0)]
        gilded_rose = GildedRose.new(items)
        47.times { gilded_rose.update_quality } 
        expect(items[0].sell_in).to eq -47
      end

      it 'decrements quality on every tick when sell_in >= 0' do
        items = [Item.new('Dagger', 47, 47)]
        gilded_rose = GildedRose.new(items)
        4.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 43
      end

      it 'decreases quality at 2x rate when sell_in is <= 0' do
        items = [Item.new('Dagger', 0, 10)]
        gilded_rose = GildedRose.new(items)
        4.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 2
      end

      it 'does not decrease quality below 0 when sell_in == 1 and quality == 1' do
        items = [Item.new('Dagger', 1, 1)]
        gilded_rose = GildedRose.new(items)
        1.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 0
      end
      
      it 'does not decrease quality below 0 when sell_in == 0 and quality == 1' do
        items = [Item.new('Dagger', 0, 1)]
        gilded_rose = GildedRose.new(items)
        1.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 0
      end

      it 'does not decrease quality below 0 when sell_in < 0 and quality == 1' do
        items = [Item.new('Dagger', -43, 1)]
        gilded_rose = GildedRose.new(items)
        1.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 0
      end

      it 'never decreases quality below 0' do
        items = [Item.new('Dagger', 47, 43)]
        gilded_rose = GildedRose.new(items)
        500.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 0
      end
    end

    context 'Aged Brie' do
      it 'decrements sell_in on every tick' do
        items = [Item.new('Aged Brie', 47, 47)]
        gilded_rose = GildedRose.new(items)
        4.times { gilded_rose.update_quality } 
        expect(items[0].sell_in).to eq 43
      end

      it 'decrements sell_in below 0' do
        items = [Item.new('Aged Brie', 0, 0)]
        gilded_rose = GildedRose.new(items)
        47.times { gilded_rose.update_quality } 
        expect(items[0].sell_in).to eq -47
      end

      it 'increments quality when sell_in is >= 0' do
        items = [Item.new('Aged Brie', 20, 20)]
        gilded_rose = GildedRose.new(items)
        10.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 30
      end

      it 'increases quality by 2 on each tick when sell_in < 0' do
        items = [Item.new('Aged Brie', 0, 20)]
        gilded_rose = GildedRose.new(items)
        10.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 40
      end

      it 'never increases quality above 50' do
        items = [Item.new('Aged Brie', 20, 49)]
        gilded_rose = GildedRose.new(items)
        10.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 50
      end
    end

    context 'Sulfuras' do
      it 'never changes sell_in value' do
        items = [Item.new('Sulfuras, Hand of Ragnaros', 47, 80)]
        gilded_rose = GildedRose.new(items)
        500.times { gilded_rose.update_quality } 
        expect(items[0].sell_in).to eq 47
      end
      
      it 'never changes quality value' do
        items = [Item.new('Sulfuras, Hand of Ragnaros', 47, 80)]
        gilded_rose = GildedRose.new(items)
        500.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 80
      end
    end

    context 'Backstage Pass' do
      it 'decrements sell_in on every tick' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 20, 20)]
        gilded_rose = GildedRose.new(items)
        10.times { gilded_rose.update_quality } 
        expect(items[0].sell_in).to eq 10
      end

      it 'decrements sell_in below 0' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 0)]
        gilded_rose = GildedRose.new(items)
        47.times { gilded_rose.update_quality } 
        expect(items[0].sell_in).to eq -47
      end

      it 'increments quality while sell_in is greater than 10' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 20, 20)]
        gilded_rose = GildedRose.new(items)
        10.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 30
      end

      it 'never increases quality above 50' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 47, 47)]
        gilded_rose = GildedRose.new(items)
        10.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 50
      end

      it 'increases quality by 2 on each tick when sell_in is <=10 and >5' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 10)]
        gilded_rose = GildedRose.new(items)
        5.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 20
      end

      it 'increases quality by 3 on each tick when sell_in is <=5 and >0' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 10)]
        gilded_rose = GildedRose.new(items)
        5.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 25
      end

      it 'increases quality by the expected profile on ticks from sell_in 15 to 0' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 15, 10)]
        gilded_rose = GildedRose.new(items)
        15.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 40
      end

      it 'sets quality to 0 as soon as sell_in ticks below 0' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 43)]
        gilded_rose = GildedRose.new(items)
        1.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 0
      end

      it 'never decreases quality below 0' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 47, 43)]
        gilded_rose = GildedRose.new(items)
        500.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 0
      end
    end

    context 'Conjured Items' do
      xit 'decrements sell_in on every tick' do
        items = [Item.new('Conjured Dagger', 47, 47)]
        gilded_rose = GildedRose.new(items)
        4.times { gilded_rose.update_quality } 
        expect(items[0].sell_in).to eq 43
      end

      xit 'decrements sell_in below 0' do
        items = [Item.new('Conjured Dagger', 0, 0)]
        gilded_rose = GildedRose.new(items)
        47.times { gilded_rose.update_quality } 
        expect(items[0].sell_in).to eq -47
      end

      xit 'decreases quality by 2 on every tick when sell_in >= 0' do
        items = [Item.new('Conjured Dagger', 47, 40)]
        gilded_rose = GildedRose.new(items)
        10.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 20
      end
      # assuming 'twice as fast' degradation is intended to include behaviour below zero
      xit 'decreases quality at 2x rate (i.e. by 4) when sell_in < 0' do
        items = [Item.new('Conjured Dagger', 0, 8)]
        gilded_rose = GildedRose.new(items)
        2.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 0
      end

      xit 'never decreases quality below 0' do
        items = [Item.new('Conjured Dagger', 47, 43)]
        gilded_rose = GildedRose.new(items)
        500.times { gilded_rose.update_quality } 
        expect(items[0].quality).to eq 0
      end
    end
  end
end
