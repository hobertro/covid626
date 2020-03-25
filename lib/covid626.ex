defmodule Covid626 do
  @san_gabriel_valley ["Alhambra", "Altadena", "Arcadia", "Avocado Heights", "Azusa", "Baldwin Park", 
  "Basset", "Bradbury", "Charter Oak", "Citrus", "Covina", "Duarte", "East Pasadena", "East San Gabriel",
  "El Monte", "Glendora", "Hacienda Heights", "City of Industry", "Industry", "Irwindale", "La Puente",
  "Mayflower Village", "Monrovia", "Monterey Park", "North El Monte", "El Monte", "Pasadena", "Rosemead",
  "Rowland Heights", "San Gabriel", "San Marino", "Sierra Madre", "South El Monte", "South Pasadena", "South San Gabriel",
  "South San Jose Hills", "Temple City", "Valinda", "Vincent", "Walnut", "West Covina", "West Puente Valley"]

  def testz() do
    case HTTPoison.get("http://www.publichealth.lacounty.gov/media/Coronavirus/locations.htm") do
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

  def filter_for_sgv(list) do
    Enum.filter(list, fn value -> 
      [head | tail] = value
      {_, _, list} = head
      [head | tail] = list
      str = head
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

  def total_cases(list) do
    Enum.reduce(list, 0, fn(tup, acc) ->
      {_, value} = tup
      acc + String.to_integer(value)
    end)
  end
end
