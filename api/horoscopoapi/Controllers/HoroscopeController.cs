using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using horoscopoapi.Models;
using System.Text.Json;
using System.Net.Http;

namespace horoscopoapi.Controllers
{
    [Route("api/v1/[controller]/[action]")]
    [ApiController]
    public class HoroscopeController : ControllerBase
    {
        /// <summary>
        /// Retrieve all data about zodiac sign.
        /// </summary>
        /// <param name="sign">Zodiac sign to request information.</param>
        /// <returns></returns>
        [HttpGet("{sign}")]
        public async Task<string> GetAllDetails([FromRoute] string sign)
        {

            var clientHandler = new HttpClientHandler
            {
                UseCookies = false,
            };

            var client = new HttpClient(clientHandler);
            var request = new HttpRequestMessage
            {
                Method = HttpMethod.Post,
                RequestUri = new Uri("https://aztro.sameerkumar.website/?sign="+ sign + "&day=today"),
                Headers =
                {
                    { "cookie", "__cfduid=d5419a42213eee4b3767e0b8704d571881620595799" },
                    { "Server", "cloudflare" },
                    { "cf-ray", "64cfb7dcef170a2e-MIA" },
                },
            };


            using (var response = await client.SendAsync(request))
            {
                var body = await response.Content.ReadAsStringAsync();

                HoroscopeModel jsonResponse = new HoroscopeModel();

                if (response.IsSuccessStatusCode)
                {
                    jsonResponse = JsonSerializer.Deserialize<HoroscopeModel>(body);
                    jsonResponse.status = response.StatusCode.ToString();
                }
                else
                {
                    jsonResponse.status = "-1";
                    jsonResponse.status_message = "Request is not in correct format.";
                }

                return JsonSerializer.Serialize(jsonResponse);
            }

        }

    }
}