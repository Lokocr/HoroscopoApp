namespace horoscopoapi.Models
{
    public class HoroscopeModel
    {
        public string date_range { get; set; }
        public string current_date { get; set; }
        public string description { get; set; }
        public string compatibility { get; set; }
        public string mood { get; set; }
        public string color { get; set; }
        public string lucky_number { get; set; }
        public string lucky_time { get; set; }

        // Response Information
        public string status { get; set; }
        public string status_message { get; set; }



    }
}