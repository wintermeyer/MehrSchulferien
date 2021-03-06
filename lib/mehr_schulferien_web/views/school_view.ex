defmodule MehrSchulferienWeb.SchoolView do
  use MehrSchulferienWeb, :view

  def truncate_url(url) do
    short_url =
      String.replace(url, "http://", "")
      |> String.replace("https://", "")
      |> String.replace("www.", "")

    if String.length(short_url) > 28 do
      ~E"""
      <a href="<%= url %>"><%= snip(short_url) %></a>
      """
    else
      ~E"""
      <a href="<%= url %>"><%= short_url %></a>
      """
    end
  end

  def truncate_email(email) do
    if String.length(email) > 28 do
      ~E"""
      <a href="mailto:<%= email %>"><%= snip(email) %></a>
      """
    else
      ~E"""
      <a href="mailto:<%= email %>"><%= email %></a>
      """
    end
  end

  defp snip(string) do
    string =
      string
      |> String.slice(0..24)

    string <> "..."
  end
end
