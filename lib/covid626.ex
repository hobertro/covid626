defmodule Covid626 do
  @san_gabriel_valley ["Alhambra", "Altadena", "Arcadia", "Avocado Heights", "Azusa", "Baldwin Park", 
  "Basset", "Bradbury", "Charter Oak", "Citrus", "Covina", "Duarte", "East Pasadena", "East San Gabriel",
  "El Monte", "Glendora", "Hacienda Heights", "City of Industry", "Industry", "Irwindale", "La Puente",
  "Mayflower Village", "Monrovia", "Monterey Park", "North El Monte", "El Monte", "Pasadena", "- Pasadena", "Rosemead",
  "Rowland Heights", "San Gabriel", "San Marino", "Sierra Madre", "South El Monte", "South Pasadena", "South San Gabriel",
  "South San Jose Hills", "Temple City", "Valinda", "Vincent", "Walnut", "West Covina", "West Puente Valley"]
  @la_county_gov "http://www.publichealth.lacounty.gov/media/Coronavirus/locations.htm"

  def get_data() do
    case make_http_request do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response = body 
         |> Floki.find("tr")
         |> filter_initial_data
         |> filter_for_sgv
         |> get_values_for_cities
        total = total_cases(response)
        {:ok, response, total}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found"
      {:error, %HTTPoison.Error{ reason: reason}} ->
        IO.inspect reason
    end
  end

  def filter_initial_data(list) do
    Enum.map(list, fn row ->
      {_, _, a} = row
      a
    end)
  end

  def make_http_request do
    HTTPoison.get(@la_county_gov)
  end

  def filter_for_sgv(list) do
    Enum.filter(list, fn value ->
      tuple     = List.first(value)
      city_list  = city_filter(tuple)
      city_name = filter_misc_values(city_list)
      Enum.member?(@san_gabriel_valley, city_name)
    end)
  end

  def city_filter(tuple) do
    {_, _, list} = tuple
    case List.first(list) do
      nil ->
        ""
      _ ->
        List.first(list)
    end
  end

  def head_filter([head | tail]) do
    head
  end

  def head_filter([]) do
    [""]
  end

  def get_values_for_cities(list) do
    Enum.map(list, fn value -> 
      [head | tail]  = value
      {_, _, city}   = head
      {_, _, number} = List.first(tail)
      city   = filter_misc_values(List.first(city))
      number = number_of_cases(List.first(number))
      %{city: city, number_of_cases: number}
    end)
  end

  def number_of_cases(number) do
    if number == "--" do
      "0"
    else 
      number
    end
  end

  def filter_misc_values(city) do
    String.replace_leading(city, "- ", "")
     |> String.replace_leading("City of ", "")
     |> String.replace_leading("Unincorporated - ", "")
     |> String.replace_trailing("***", "")
     |> String.replace_trailing("**", "")
     |> String.replace_trailing("*", "")
  end

  def total_cases(list) do
    Enum.reduce(list, 0, fn(map, acc) ->
      acc + String.to_integer(map[:number_of_cases])
    end)
  end
end
