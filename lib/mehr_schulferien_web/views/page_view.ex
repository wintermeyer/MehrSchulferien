defmodule MehrSchulferienWeb.PageView do
  use MehrSchulferienWeb, :view

  alias MehrSchulferien.Locations

  def number_schools() do
    Locations.number_schools()
  end

  def get_school_period(periods) do
    case Enum.filter(periods, & &1.is_school_vacation) do
      [] -> nil
      [period] -> period
      periods -> select_display_period(periods)
    end
  end

  defp select_display_period(periods) do
    periods |> Enum.sort(&(&1.display_priority >= &2.display_priority)) |> hd
  end

  def display_period_info?(_, _, nil), do: false

  def display_period_info?(date, dates, period) do
    if period.is_school_vacation do
      if date == hd(dates) do
        true
      else
        date == period.starts_on
      end
    end
  end

  def get_period_colspan(date, last_date, period) do
    ends_on =
      if Date.compare(last_date, period.ends_on) == :gt do
        period.ends_on
      else
        last_date
      end

    Date.diff(ends_on, date) + 1
  end

  def show_period_info(period, colspan) do
    name = period.holiday_or_vacation_type.colloquial
    name_len = String.length(name)
    span = colspan * 4

    if name_len + 16 < span do
      "#{name} #{show_period_date(period)}"
    else
      if name_len < span do
        name
      else
        String.slice(name, 0, span)
      end
    end
  end

  defp show_period_date(period) do
    "(#{ViewHelpers.format_date_range(period.starts_on, period.ends_on, :short)})"
  end

  def get_non_school_period(_, nil, periods) do
    case Enum.filter(periods, &non_school_period/1) do
      [] -> nil
      [period] -> period
      periods -> select_display_period(periods)
    end
  end

  def get_non_school_period(date, period, periods) do
    if Date.compare(date, period.ends_on) == :gt do
      get_non_school_period(date, nil, periods)
    end
  end

  defp non_school_period(period) do
    period.holiday_or_vacation_type.name == "Wochenende" or period.is_school_vacation == false
  end
end
