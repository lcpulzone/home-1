require 'minitest/autorun'
require 'minitest/pride'
require './lib/building'
require './lib/apartment'
require './lib/renter'
require 'pry'

class BuildingTest < Minitest::Test
  def setup
    @building = Building.new
    @unit1 = Apartment.new({
      number: "A1",
      monthly_rent: 1200,
      bathrooms: 1,
      bedrooms: 1
    })
    @unit2 = Apartment.new({
      number: "B2",
      monthly_rent: 999,
      bathrooms: 2,
      bedrooms: 2
    })
  end

  def test_it_exists
    assert_instance_of Building, @building
  end

  def test_it_starts_with_no_units
    assert_equal [], @building.units
  end

  def test_it_adds_units
    @building.add_unit(@unit1)
    @building.add_unit(@unit2)

    assert_equal [@unit1, @unit2], @building.units
  end

  def test_it_has_renters
    assert_equal [], @building.renters

    @building.add_unit(@unit1)
    @building.add_unit(@unit2)
    renter1 = Renter.new("Aurora")
    renter2 = Renter.new("Tim")
    @unit1.add_renter(renter1)
    @unit2.add_renter(renter2)

    assert_equal ["Aurora", "Tim"], @building.renters
  end

  def test_it_has_average_rent
    @building.add_unit(@unit1)
    @building.add_unit(@unit2)

    assert_equal 1099.5, @building.average_rent
  end

  def test_it_can_get_rented_units
    building = Building.new
    unit1 = Apartment.new({number: "A1", monthly_rent: 1200, bathrooms: 1, bedrooms: 1})
    unit2 = Apartment.new({number: "B2", monthly_rent: 999, bathrooms: 1, bedrooms: 2})
    unit3 = Apartment.new({number: "C3", monthly_rent: 1150, bathrooms: 2, bedrooms: 2})
    unit4 = Apartment.new({number: "D4", monthly_rent: 1500, bathrooms: 2, bedrooms: 3})
    renter1 = Renter.new("Spencer")
    building.add_unit(unit1)
    building.add_unit(unit2)
    building.add_unit(unit3)

    assert_equal [], building.rented_units

    unit2.add_renter(renter1)

    assert_equal [unit2], building.rented_units
  end

  def test_it_gets_renter_with_highest_rent
    building = Building.new
    unit1 = Apartment.new({number: "A1", monthly_rent: 1200, bathrooms: 1, bedrooms: 1})
    unit2 = Apartment.new({number: "B2", monthly_rent: 999, bathrooms: 1, bedrooms: 2})
    unit3 = Apartment.new({number: "C3", monthly_rent: 1150, bathrooms: 2, bedrooms: 2})
    unit4 = Apartment.new({number: "D4", monthly_rent: 1500, bathrooms: 2, bedrooms: 3})
    renter1 = Renter.new("Spencer")
    renter2 = Renter.new("Jessie")
    renter3 = Renter.new("Max")
    building.add_unit(unit1)
    building.add_unit(unit2)
    building.add_unit(unit3)
    unit2.add_renter(renter1)

    assert_equal renter1, building.renter_with_highest_rent

    unit1.add_renter(renter2)

    assert_equal renter2, building.renter_with_highest_rent

    unit3.add_renter(renter3)

    assert_equal renter2, building.renter_with_highest_rent
  end

  def test_it_gets_units_by_number_of_bedrooms
    building = Building.new
    unit1 = Apartment.new({number: "A1", monthly_rent: 1200, bathrooms: 1, bedrooms: 1})
    unit2 = Apartment.new({number: "B2", monthly_rent: 999, bathrooms: 1, bedrooms: 2})
    unit3 = Apartment.new({number: "C3", monthly_rent: 1150, bathrooms: 2, bedrooms: 2})
    unit4 = Apartment.new({number: "D4", monthly_rent: 1500, bathrooms: 2, bedrooms: 3})
    renter1 = Renter.new("Spencer")
    renter2 = Renter.new("Jessie")
    renter3 = Renter.new("Max")
    building.add_unit(unit1)
    building.add_unit(unit2)
    building.add_unit(unit3)
    unit2.add_renter(renter1)
    unit1.add_renter(renter2)
    unit3.add_renter(renter3)
    building.add_unit(unit4)

    expected = {
      2 => ["B2", "C3"],
      3 => ["D4"],
      1 => ["A1"]
    }

    assert_equal expected, building.units_by_number_of_bedrooms
  end

  def test_it_gets_annual_breakdown
    building = Building.new
    unit1 = Apartment.new({number: "A1", monthly_rent: 1200, bathrooms: 1, bedrooms: 1})
    unit2 = Apartment.new({number: "B2", monthly_rent: 999, bathrooms: 2, bedrooms: 2})
    unit3 = Apartment.new({number: "C3", monthly_rent: 1150, bathrooms: 2, bedrooms: 2})
    renter1 = Renter.new("Spencer")
    renter2 = Renter.new("Jessie")
    building.add_unit(unit1)
    building.add_unit(unit2)
    building.add_unit(unit3)
    unit2.add_renter(renter1)
    unit1.add_renter(renter2)

    expected = {"Jessie" => 14400, "Spencer" => 11988}
    assert_equal expected, building.annual_breakdown
  end

  def test_it_gets_rooms_by_renter
    building = Building.new
    unit1 = Apartment.new({number: "A1", monthly_rent: 1200, bathrooms: 1, bedrooms: 1})
    unit2 = Apartment.new({number: "B2", monthly_rent: 999, bathrooms: 2, bedrooms: 2})
    unit3 = Apartment.new({number: "C3", monthly_rent: 1150, bathrooms: 2, bedrooms: 2})
    renter1 = Renter.new("Spencer")
    renter2 = Renter.new("Jessie")
    building.add_unit(unit1)
    building.add_unit(unit2)
    building.add_unit(unit3)
    unit2.add_renter(renter1)
    unit1.add_renter(renter2)

    expected = {
      renter1 => {bathrooms: 2, bedrooms: 2},
      renter2 => {bathrooms: 1, bedrooms: 1}
    }

    assert_equal expected, building.rooms_by_renter
  end
end
