defmodule MehrSchulferienWeb.PageController do
  use MehrSchulferienWeb, :controller

  alias MehrSchulferien.Locations
  alias MehrSchulferien.Locations.FederalState
  alias MehrSchulferien.Locations.Country
  alias MehrSchulferien.Timetables.Category
  alias MehrSchulferien.Repo
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    {country, federal_states} = get_locations("deutschland")

    render(conn, "index.html", federal_states: federal_states,
                               country: country,
                               religion_categories: get_religion_categories())
  end

  defp get_locations(id) do
    country = Locations.get_country!(id)

    query = from fs in FederalState, where: fs.country_id == ^country.id,
                                     order_by: fs.name,
                                     preload: [:cities, :schools]
    federal_states = Repo.all(query)

    {country, federal_states}
  end

  defp get_religion_categories() do
    query = from c in Category, where: c.for_students == true and
                                       c.is_a_religion == true
    Repo.all(query)
  end
end
