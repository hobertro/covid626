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
        response = body |> Floki.find("tr")
        response = Enum.map(response, fn row ->
          {_, _, a} = row # pattern matching to only get the lists of relevant data
        a
        end)
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

  def make_http_request do
    HTTPoison.get(@la_county_gov)
  end

  def filter_for_sgv(list) do
    Enum.filter(list, fn value -> 
      [head | _] = value
      {_, _, list} = head
      [head | _] = list
      str = head
      str = filter_misc_values(str)
      Enum.member?(@san_gabriel_valley, str)
    end)
  end

  def get_values_for_cities(list) do
    Enum.map(list, fn value -> 
      [head | tail]  = value
      {_, _, city}   = head
      {_, _, number} = List.first(tail)
      city = List.first(city)
      number = List.first(number)
      {city, number}
    end)
  end

  def filter_misc_values(city) do
    str = String.replace_leading(city, "- ", "")
    str = String.replace_leading(city, "City of ", "")
    # str = String.replace_leading(city, "Unincorporated - ", "")
    str = String.replace_trailing(str, "***", "")
    str = String.replace_trailing(str, "**", "")
    String.replace_trailing(str, "*", "")
  end

  def total_cases(list) do
    Enum.reduce(list, 0, fn(tup, acc) ->
      {_, value} = tup
      if value == "--" do
        acc + 0
      else
        acc + String.to_integer(value)
      end
    end)
  end
end
