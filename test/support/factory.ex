defmodule MehrSchulferien.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: MehrSchulferien.Repo

  alias MehrSchulferien.Calendars.{HolidayOrVacationType, Period, Religion}
  alias MehrSchulferien.Maps.{Location, ZipCode, ZipCodeMapping}

  def holiday_or_vacation_type_factory(attrs) do
    name = attrs[:name] || Enum.random(["Herbst", "Sommer", "Weihnachts"])
    country = insert(:country)

    holiday_or_vacation_type = %HolidayOrVacationType{
      name: name,
      colloquial: "#{name}ferien",
      default_display_priority: 3,
      default_html_class: "green",
      default_is_listed_below_month: true,
      default_is_school_vacation: true,
      default_is_valid_for_students: true,
      wikipedia_url: "https://de.wikipedia.org/wiki/Schulferien##{name}ferien",
      country_location_id: country.id
    }

    merge_attributes(holiday_or_vacation_type, attrs)
  end

  def location_factory do
    [:country, :federal_state, :county, :city]
    |> Enum.random()
    |> build()
  end

  def country_factory do
    %Location{name: "Deutschland", code: "D", is_country: true}
  end

  def federal_state_factory do
    country = insert(:country)

    %Location{
      name: "Berlin",
      code: "BE",
      is_federal_state: true,
      parent_location_id: country.id
    }
  end

  def county_factory do
    federal_state = insert(:federal_state)

    %Location{
      name: "Berlin",
      code: "BE",
      is_county: true,
      parent_location_id: federal_state.id
    }
  end

  def city_factory do
    county = insert(:county)

    %Location{
      name: Enum.random(["Berlin", "Dresden", "Frankfurt", "Hamburg"]),
      code: "BE",
      is_city: true,
      parent_location_id: county.id
    }
  end

  def period_factory do
    federal_state = insert(:federal_state)

    %Period{
      holiday_or_vacation_type: build(:holiday_or_vacation_type),
      created_by_email_address: "sw@wintermeyer-consulting.de",
      display_priority: 3,
      starts_on: Faker.Date.between(~D[2010-12-01], ~D[2015-12-01]),
      ends_on: Faker.Date.between(~D[2016-12-01], ~D[2019-12-01]),
      location_id: federal_state.id
    }
  end

  def religion_factory do
    name = Enum.random(["Christentum", "Judentum", "Islam"])

    %Religion{
      name: name,
      wikipedia_url: "https://de.wikipedia.org/wiki/#{name}"
    }
  end

  def zip_code_factory do
    country = insert(:country)

    %ZipCode{
      value: Faker.format("#####"),
      country_location_id: country.id
    }
  end

  def zip_code_mapping_factory do
    location = insert(:city)
    zip_code = insert(:zip_code)

    %ZipCodeMapping{
      location_id: location.id,
      zip_code_id: zip_code.id,
      lat: 51.2,
      lon: 10.5
    }
  end
end
