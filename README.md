# Gilded Rose tech test

The code in this repository is my attempt at this well-known kata developed by [Terry Hughes](http://iamnotmyself.com/2011/02/13/refactor-this-the-gilded-rose-kata/), commonly used as a tech test to assess a candidate's ability to read, refactor and extend legacy code. The Ruby translation of the kata legacy code is sourced from [Emily Bache](https://github.com/emilybache/GildedRose-Refactoring-Kata/), and is preserved in this repo as lib/original_gilded_rose.rb.

I recently completed working through Sandi Metz's brilliant [_99 Bottles of OOP_](https://sandimetz.com/99bottles). To help embed what I had learned, I wanted an opportunity to practise my OOP, TDD and refactoring skills, and I thought Gilded Rose would present a good chance to do that. I really wanted to take my time through this exercise, working methodically to get the most out of the potential learning opportunities and to explore my design options. I think Gilded Rose is intended to take one or two hours; it's safe to say I allowed myself significantly more time than that.

## How to use

Clone the repo, and navigate to the project directory.

### To install dependencies

Run:

```shell
bundle install
```

### To run the tests

Run:

```shell
rspec
```

You'll see that all tests are passing, with 98.72% test coverage. The remaining % is accounted for by `Item#to_s`, which is not exercised by the requirements and therefore I chose not to test, particularly as I did not alter the `Item` class. Similarly, I decided that writing unit tests for my code would not be a good use of time and energy, in light of my goals for undertaking this kata; I'm comfortable defending this decision.

You might also compare the functioning of my refactored solution with the legacy code via the REPL.

## The brief

Courtesy of [Makers Academy](https://github.com/makersacademy/course/blob/main/individual_challenges/gilded_rose.md):

> Choose legacy code in the language of your choice. The aim is to practice good design in the language of your choice. Refactor the code in such a way that adding the new "conjured" functionality is easy.
>
> You don't need to clone the repo if you don't want to. Feel free to copy the ruby code into a new folder and write your tests from scratch.
>
> HINT: Test first FTW!

### Gilded Rose Requirements / Specification

>Hi and welcome to team Gilded Rose. As you know, we are a small inn with a prime location in a
prominent city ran by a friendly innkeeper named Allison. We also buy and sell only the finest goods.
Unfortunately, our goods are constantly degrading in quality as they approach their sell by date. We
have a system in place that updates our inventory for us. It was developed by a no-nonsense type named
Leeroy, who has moved on to new adventures. Your task is to add the new feature to our system so that
we can begin selling a new category of items. First an introduction to our system:
>
>- All items have a SellIn value which denotes the number of days we have to sell the item
>- All items have a Quality value which denotes how valuable the item is
>- At the end of each day our system lowers both values for every item
>
>Pretty simple, right? Well this is where it gets interesting:
>
>- Once the sell by date has passed, Quality degrades twice as fast
>- The Quality of an item is never negative
>- "Aged Brie" actually increases in Quality the older it gets
>- The Quality of an item is never more than 50
>- "Sulfuras", being a legendary item, never has to be sold or decreases in Quality
>- "Backstage passes", like aged brie, increases in Quality as its SellIn value approaches; Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but Quality drops to 0 after the concert
>
>We have recently signed a supplier of conjured items. This requires an update to our system:
>
>- "Conjured" items degrade in Quality twice as fast as normal items
>
>Feel free to make any changes to the UpdateQuality method and add any new code as long as everything
still works correctly. However, do not alter the Item class or Items property as those belong to the
goblin in the corner who will insta-rage and one-shot you as he doesn't believe in shared code
ownership (you can make the UpdateQuality method and Items property static if you like, we'll cover
for you).
>
>Just for clarification, an item can never have its Quality increase above 50, however "Sulfuras" is a
legendary item and as such its Quality is 80 and it never alters.

## My process

- make notes on the requirements, build my understanding of them.
- write tests to cover the requirements, playing with the code in the REPL to explore areas where my understanding was unclear or questions had emerged.
- first round of refactoring: extract the procedures related to each type of item into a specific update method, `GildedRose#update_{type_of_item}`. These are called from a switch statement in `GildedRose#update_quality`. Things are much clearer now!
- realise I have failed to account for certain boundary conditions in my test suite (re: doubled rates of quality increase/decrease at the 1 and 49 boundaries). Compare my current code's functionality against the legacy code, realise I have failed to preserve this behaviour. Write tests to cover these cases (including anticipated equivalents for the future `Conjured` type), and test-drive implementation code that gets me back to green. Also add test cases for some behaviours not captured in the requirements, but that the legacy code nonetheless demonstrates.
- second major refactoring: move the switch statement into an `Updater` class containing a factory, `Updater.for`, that instantiates polymorphic subclasses of itself that wrap and update the `Item`. At this point, `GildedRose#update_quality` is 3 LOC long (down from 43), and I believe the GildedRose class is open for the new requirement.
- take this to a coaching session with [Kay Lack](https://github.com/neoeno), and receive feedback that the overall code at this point is not Open/Closed for the new requirement. A branch must be added to the hard-coded conditional in the factory for it to create a new `ConjuredUpdater` — logically, the code at this point must therefore be _Open for modification_.
- third refactoring: informed by the variant factory solutions in Chapter 7 of _99 Bottles of OOP_, add a 'registry' to the factory, which holds a list of classes that are candidates to handle an `Item`. This disperses the choosing logic to the candidate classes, which register themselves. As a result, one need only write a new subclass of `Updater` to extend the functionality — the factory is now Open/Closed!
NB: this requires the de facto loss of `NormalUpdater`, via integrating its `#update` procedure into the superclass, in order to avoid a situation where `Updater` and `NormalUpdater` competed to handle the 'else' case of `Item` names. This also means `SulfurasUpdater` must overwrite `#update` functionality rather than neatly inheriting from the parent. I don't like the loss of a clearly-named class for Normal-typed items, but it would be far worse to label the superclass with a `Normal` prefix — the resulting `NormalUpdater.for(item).update` call in `GildedRose#update_quality` would be non-expressive and misleading.
- unpend my 'Conjured' tests, and implement the new type requirement by test-driving the writing of `ConjuredUpdater`.

## My reflections

(notes)

- importance of preserving legacy code (dys)functionality. In the absence of a client with whom to collaborate on clearer requirements, always preserve existing behaviours even if you think they are counterintuitive or 'stinky' — for example, Sulfuras not being autocorrected to its canon `quality` value, or having a non-user-determined `sell_in` value that better communicates the immateriality of this attribute to that item type. As someone with fingers always itching to tweak and improve, it was good to have an opportunity to practise sitting with the discomfort of not meddling!
- missing boundary cases
- working to open up the factory in third round of refactoring forced me to get to grips with Chapter 7 of _99 Bottles_, which was the section I understood least well on my work-through. I found this work quite challenging, particularly because good resources on these techniques in a more general sense seem to be hard to find (or were couched in terms of C++ or Java, languages unknown to me), and so it was difficult to place the concepts in their broader context. #TODO: say more
- "put not your trust in princes". Using the Metz video
- remaining questions around Strategy factories, composition vs. inheritance, etc. I wasn't able to imagine a way in which I could implement a compositional pattern while still having a polymorphic wrapper class around `Item` instances, which was the only real object-oriented solution I felt I had in my toolkit. Therefore, inheritance. I'm comfortable defending my use of inheritance here, although I would have liked to be in a position to better understand the alternatives open to me (within the constraints of the kata).
