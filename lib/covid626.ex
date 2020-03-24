defmodule Covid626 do
  
  @san_gabriel_valley ["Alhambra", "Altadena", "Pasadena", "Monterey Park", "Arcadia", "Rosemead", 
  "El Monte", "South El Monte", "South Pasadena", "Temple City", "West Covina",
  "Rowland Heights", "Monrovia", "Walnut"]

  def get_cases_url() do
    case HTTPoison.get("http://www.publichealth.lacounty.gov/media/Coronavirus/locations.htm") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response = body |> Floki.find("tr")
        response = Enum.filter(response, fn row ->
          list1 = Tuple.to_list(row)
          Enum.any?(list1, fn thing ->
IO.inspect thing
            testz = Enum.member?(@san_gabriel_valley, thing)
            Enum.member?(@san_gabriel_valley, thing)
          end)
        end)
        {:ok, response}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found"
      {:error, %HTTPoison.Error{ reason: reason}} ->
        IO.inspect reason
    end
  end
end
