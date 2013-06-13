using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Elcondor.UI.Utilities;
using ElcondorBiz;
using LinqToElcondor;
using System.Text;
using System.Globalization;
using CaptchaMvc.HtmlHelpers;
using System.Globalization;
using Elcondor.Models;
using System.Web.Routing;

namespace Elcondor.Controllers {
    [HandleError]
    public class HomeController : Controller {
        public ActionResult Index () {
            ViewData["NewsListHTML"] = GridNewsHelper.GetNewsListHTML();
            TblPage page = BizDictionary.GetPageById(Constants.PageIndexId);
            ViewData["PageTitle"] = page.Title;
            ViewData["PageContent"] = page.Text;
            ViewData["GridCountryList"] = BizDictionary.GetCountryAllInfo();
            return View();
        }

        public ActionResult Avia () {
            TblPage page = BizDictionary.GetPageById(Constants.PageAviaId);
            ViewData["PageTitle"] = page.Title;
            ViewData["PageContent"] = page.Text;
            return View();
        }

        public ActionResult Offers () {
            return View();
        }

        public ActionResult MessageSent () {
            return View();
        }

        public ActionResult RentList () {
            //ViewData["CountryListJSON"] = UIHelper.GetCountryListDataJson();
            ViewData["CountryItems"] = UIHelper.GetCountryListDataJson2();
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult RentList (string tara_txtDatefrom, string tara_txtDateto, string txtAdults, string txtKids, string txtCountries, string txtRegions, string txtCities) {
            string countryName = string.Empty;
            string regionName = string.Empty;
            string cityName = string.Empty;
            List<string> countriesStr = txtCountries.Split('|').ToList();
            List<int> countryIds = new List<int>();
            foreach (string str in countriesStr) {
                if (str.Length > 0) {
                    countryIds.Add(int.Parse(str));
                    countryName = countryName + BizCountry.GetCountryById(int.Parse(str)).Name.TrimEnd() + ",";
                }
            }
            countryName = countryName.Substring(0, countryName.Length - 1);
            List<string> regionsStr = txtRegions.Split('|').ToList();
            List<int> regionsIds = new List<int>();
            foreach (string str in regionsStr) {
                if (str.Length > 0) {
                    if (int.Parse(str) == -1) {
                        regionsIds = new List<int>();
                        foreach (TblRegion reg in BizRegion.GetRegionListByCountryId(countryIds[0]))
                            countryIds.Add(reg.Id);
                        break;
                    }
                    regionsIds.Add(int.Parse(str));
                    regionName = regionName + BizRegion.GetRegionById(int.Parse(str)).Name.TrimEnd() + ",";
                }
            }
            if (!string.IsNullOrEmpty(regionName))
                regionName = regionName.Substring(0, regionName.Length - 1);
            List<string> citysStr = txtCities.Split('|').ToList();
            List<int> citysIds = new List<int>();
            foreach (string str in citysStr) {
                if (str.Length > 0) {
                    if (int.Parse(str) == -1) {
                        citysIds = new List<int>();
                        foreach (TblCity cty in BizCity.GetCityListByRegionId(regionsIds[0]))
                            countryIds.Add(cty.Id);
                        break;
                    }
                    citysIds.Add(int.Parse(str));
                    cityName = cityName + BizCity.GetCityById(int.Parse(str)).Name.TrimEnd() + ",";
                }
            }
            if (!string.IsNullOrEmpty(cityName))
                cityName = cityName.Substring(0, countryName.Length - 1);
            string countries = string.Empty;
            string regions = string.Empty;
            string cities = string.Empty;
            foreach (int cn in countryIds) {
                countries += "|" + cn;
            }
            foreach (int rn in regionsIds) {
                regions += "|" + rn;
            }
            foreach (int cty in cities) {
                cities += "|" + cty;
            }
            if (ValidateSearchParams(txtCountries, tara_txtDatefrom, tara_txtDateto, txtAdults, txtKids)) {
                Response.Redirect(string.Format("/RentSearchResult?country={0}&region={1}&datefrom={2}&dateto={3}&adults={4}&kids={5}&countryName={6}&regionName={7}&cityName={8}", countries, regions, tara_txtDatefrom, tara_txtDateto, txtAdults, txtKids, countryName, regionName, cityName));
            }
            ViewData["CountryItems"] = UIHelper.GetCountryListDataJson2();
            return View();
        }

        public ActionResult RentSearchResult () {
            try {
                //string country = Request.QueryString["country"].ToString();
                IFormatProvider culture = new CultureInfo("ru-RU", true);
                DateTime datefrom = DateTime.ParseExact(Request.QueryString["datefrom"].ToString(), "dd/MM/yyyy", culture, DateTimeStyles.NoCurrentDateDefault);
                DateTime dateto = DateTime.ParseExact(Request.QueryString["dateto"].ToString(), "dd/MM/yyyy", culture, DateTimeStyles.NoCurrentDateDefault);
                int adults = int.Parse(Request.QueryString["adults"].ToString());
                int kids = int.Parse(Request.QueryString["kids"].ToString());
                string countryName = Request.QueryString["countryName"].ToString();
                string regionName = Request.QueryString["regionName"].ToString();
                string cityName = Request.QueryString["cityName"].ToString();
                string countriesStr = Request.QueryString["country"].ToString();
                string regionStr = Request.QueryString["region"].ToString();

                ViewData["CountryNames"] = countryName;
                ViewData["RegionNames"] = regionName;
                ViewData["CityNames"] = cityName;
                ViewData["DateFrom"] = datefrom.ToString("dd.MM.yyyy");
                ViewData["DateTo"] = dateto.ToString("dd.MM.yyyy");
                ViewData["Adults"] = adults;
                ViewData["Kids"] = kids;
                List<TaratripBiz.Model.TblHotelView> items = TaratripBiz.BizHotelSearch.GetHotelSearchResult(string.Empty, countriesStr, regionStr);

                ViewData["NumberResults"] = items.Count;

                if (Request.QueryString["priceMin"] != null) {
                    try {
                        items = items.Where(p => p.MinPricePerPerson >= double.Parse(Request.QueryString["priceMin"])).ToList();
                    } catch { }
                }
                if (Request.QueryString["priceMax"] != null) {
                    try {
                        items = items.Where(p => p.MinPricePerPerson <= double.Parse(Request.QueryString["priceMax"])).ToList();
                    } catch { }
                }
                if (Request.QueryString["starRating"] != null) {
                    try {
                        items = items.Where(p => p.StarRating >= double.Parse(Request.QueryString["starRating"])).ToList();
                    } catch { }
                }
                ViewData["SearchResultsGrid"] = GridHotelSearchResult.GetSearchResultHTML(items, datefrom.ToString("dd.MM.yyyy"), dateto.ToString("dd.MM.yyyy")
                                                                                            , adults, kids);
                //string formVars = Request.QueryString["formVars"];
                //if (!string.IsNullOrEmpty(formVars)) {
                //    List<string> formArgs = UIHelper.SplitByString(formVars, "||").ToList();
                //    List<NameValue> formItems = new List<NameValue>();
                //    NameValue[] array = new NameValue[formArgs.Count()];
                //    foreach (string arg in formArgs) {
                //        if (!string.IsNullOrEmpty(arg)) {
                //            string[] item = UIHelper.SplitByString(arg, "__").ToArray();
                //            if (item[1] != null)
                //                formItems.Add(new NameValue(item[0], HttpUtility.UrlDecode(item[1])));
                //        }
                //    }
                //    try {
                //        ViewData["SearchResultsGrid"] = GridHotelSearchResult.GetGridHotelSearchGridHTML(UIHelper.FillHotelSearchParameter((NameValue[])(formItems.ToArray<NameValue>())));
                //    } catch (Exception ex) {
                //        this.ModelState.AddModelError("errorDetail", ex.Message);
                //    }
                //}
            } catch {
                Response.Redirect("/RentList");
            }
            return View();
        }

        public ActionResult About () {
            TblPage page = BizDictionary.GetPageById(Constants.PageIndexId);
            ViewData["PageTitle"] = page.Title;
            ViewData["PageContent"] = page.Text;
            return View();
        }

        public ActionResult Articles () {
            return View();
        }

        public ActionResult Faq () {
            TblPage page = BizDictionary.GetPageById(Constants.PageFaqId);
            ViewData["PageTitle"] = page.Title;
            ViewData["PageContent"] = page.Text;
            return View();
        }

        public ActionResult ForAgents () {
            TblPage page = BizDictionary.GetPageById(Constants.PageForAgentsId);
            ViewData["PageTitle"] = page.Title;
            ViewData["PageContent"] = page.Text;
            return View();
        }

        public ActionResult ViewArticle () {
            int id = int.Parse(Request.QueryString["id"].ToString());
            DateTime date = BindSightseeingData(id);
            ViewData["ArticleDate"] = string.Format("{0} {1}", CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(date.Month), date.ToString("yyyy"));
            return View();
        }

        public ActionResult HotelBooking () {
            int id = int.Parse(Request.QueryString["id"].ToString());
            BindHotelData(id);
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult HotelBooking (string txtId, string txtName, string txtPersPhone, string txtEmail, string datefrom, string dateto, string txtMessage
                                            , string txtAdults, string txtKids) {
            if (this.IsCaptchaVerify("Неверно указан код с картинки.")) {
                TempData["Message"] = "Message: captcha is valid.";
                //return View();
            }
            if (ValidateHotelBooking(txtName, txtPersPhone, datefrom, dateto)) {
                TaratripLinq.TblHotel hotel = TaratripBiz.BizHotel.GetHotelById(int.Parse(txtId));
                UIHelper.SendNotificationEmail(Constants.MsgAdminEmailAddress
                    , string.Format(Constants.MsgHotelBookingSbjTemplate, txtName, txtPersPhone, hotel.Name, BizCountry.GetCountryById(hotel.CountryId).Name)
                    , string.Format(Constants.MsgHotelBookingBodyTemplate, txtName, txtEmail, txtPersPhone, hotel.Name, BizCountry.GetCountryById(hotel.CountryId).Name, BizCity.GetCityById(hotel.CityId).Name, DateTime.ParseExact(datefrom, "dd/MM/yyyy", new CultureInfo("ru-RU", true), DateTimeStyles.NoCurrentDateDefault).ToString("dd.MM.yyyy"), DateTime.ParseExact(dateto, "dd/MM/yyyy", new CultureInfo("ru-RU", true), DateTimeStyles.NoCurrentDateDefault).ToString("dd.MM.yyyy"), txtMessage));
                Response.Redirect("/MessageSent");
            }
            BindHotelData(int.Parse(txtId));
            RouteValueDictionary rvd = new RouteValueDictionary();
            rvd.Add("id", txtId);
            rvd.Add("datefrom", datefrom);
            rvd.Add("dateto", dateto);
            rvd.Add("adults", txtAdults);
            rvd.Add("kids", txtKids);
            return RedirectToAction("HotelBooking", "Home", rvd);
        }

        public ActionResult CountryTours () {
            try {
                int id = int.Parse(Request.QueryString["id"].ToString());
                TblCountry country = BizCountry.GetCountryById(id);
                ViewData["CountryName"] = country.Name;
                ViewData["CountryId"] = country.Id;
                Session["CountryId"] = country.Id;
                ViewData["GridList"] = GridTourListHelper.GetTourGridHTML(BizTour.GetTourListByCountryId(id));
            } catch {
                ViewData["GridList"] = GridTourListHelper.GetTourGridHTML(BizTour.GetTourListByCountryId(null));
            }
            return View();
        }

        public ActionResult ViewObject () {
            int hotelId = int.Parse(Request.QueryString["id"].ToString());
            BindHotelData(hotelId);

            IFormatProvider culture = new CultureInfo("ru-RU", true);
            DateTime datefrom = DateTime.ParseExact(Request.QueryString["datefrom"].ToString(), "dd/MM/yyyy", culture, DateTimeStyles.NoCurrentDateDefault);
            DateTime dateto = DateTime.ParseExact(Request.QueryString["dateto"].ToString(), "dd/MM/yyyy", culture, DateTimeStyles.NoCurrentDateDefault);
            int adults = int.Parse(Request.QueryString["adults"].ToString());
            int kids = int.Parse(Request.QueryString["kids"].ToString());
            ViewData["UrlBackToSearch"] = string.Format("../../RentSearchResult?city={0}&datefrom={1}&dateto={2}&adults={3}&kids={4}", ViewData["HotelCountryName"]
                                                , datefrom.ToString("dd.MM.yyyy"), dateto.ToString("dd.MM.yyyy"), adults, kids);

            List<TaratripLinq.TblHotelImageGallery> imgs = TaratripBiz.BizHotel.GetHotelImageGallery(hotelId);
            StringBuilder sb = new StringBuilder();
            StringBuilder sbThumbs = new StringBuilder();
            int i = 1;
            foreach (TaratripLinq.TblHotelImageGallery img in imgs) {
                //sb.Append(string.Format("{{ url: \"../../Content/UserImages/HotelImages/hotel_{0}_image_{1}.jpg\", 
                //title: \"{2}\", count: \"{3}\", imageHeight: \"215\", imageWidth: \"260\", urlTwo: \"\", titleTwo: \"\"
                //, countTwo: \"\", imageHeightTwo: \"\", imageWidthTwo: \"\" }},", img.HotelId, img.Id, img.Description, i));
                //sb.Append(string.Format(
                //"{{\"image\":\"../../Content/UserImages/HotelImages/hotel_{0}_image_{1}.jpg\",\"caption\":\"{2}\",\"link\":\"#\",\"title\":\"{2}\"}},"
                //, img.HotelId, img.Id, img.Description
                sb.Append(string.Format("<li class=\"touchcarousel-item\"><img src=\"../../Content/UserImages/HotelImages/hotel_{0}_image_{1}.jpg\" width=\"200\" height=\"200\" /></li>",
                                        img.HotelId, img.Id
                ));
                sbThumbs.Append(string.Format("<li><a href=\"../../Content/UserImages/HotelImages/hotel_{0}_image_{1}.jpg\" rel=\"prettyPhoto[pp_gal]\" title=\"{2}\"><img src=\"../../Content/UserImages/HotelImages/hotel_{0}_image_{1}.jpg\" width=\"50\" height=\"50\" /></a></li>"
                    , img.HotelId, img.Id, img.Description));
                i++;
            }
            //ViewData["mycarousel_itemList"] = sb.ToString();
            ViewData["HotelImageList"] = sb.ToString();
            ViewData["HotelImageCount"] = imgs.Count;
            ViewData["HotelThumbImageList"] = sbThumbs.ToString();
            return View();
        }

        private void BindHotelData (int hotelId) {
            TaratripLinq.TblHotel hotel = TaratripBiz.BizHotel.GetHotelById(hotelId);
            ViewData["HotelCityId"] = hotel.CityId;
            ViewData["HotelCityIName"] = BizCity.GetCityById(hotel.CityId).Name;
            ViewData["HotelId"] = hotel.Id;
            ViewData["txtAddDesc"] = hotel.AdditionalDescription;
            ViewData["HotelAccomodationTypeId"] = hotel.AccomodationTypeId;
            ViewData["HotelCountryId"] = hotel.CountryId;
            ViewData["HotelCountryName"] = BizCountry.GetCountryById(hotel.CountryId).Name;
            ViewData["HotelDescription"] = hotel.Description;
            ViewData["HotelDistanceToBeach"] = hotel.DistanceToBeach;
            ViewData["HotelDistrictId"] = hotel.DistrictId;
            ViewData["HotelDistrictName"] = BizRegion.GetRegionById(hotel.DistrictId.Value).Name;
            ViewData["HotelHotelStatusId"] = hotel.HotelStatusId;
            //ViewData["HotelIsRent"] = hotel.IsRent;
            ViewData["HotelAddress"] = hotel.Address;
            ViewData["HotelLongitude"] = hotel.Longitude.HasValue ? Math.Round(hotel.Longitude.Value, 6).ToString().Replace(',', '.') : string.Empty;
            ViewData["HotelLatitude"] = hotel.Latitude.HasValue ? Math.Round(hotel.Latitude.Value, 6).ToString().Replace(',', '.') : string.Empty;
            ViewData["HotelIsTop10"] = hotel.IsTop10;
            ViewData["HotelMaxPeople"] = hotel.MaxPeople;
            ViewData["HotelMinPricePerPerson"] = hotel.MinPricePerPerson;
            ViewData["HotelName"] = hotel.Name;
            ViewData["HotelStarRating"] = hotel.StarRating;
            ViewData["HotelThumbImage"] = hotel.ThumbImage;
            ViewData["HotelNumberOfRooms"] = TaratripBiz.BizHotelRoom.GetHotelRoomList(hotelId).Count;
            ViewData["HotelLatLng"] = "[0,0]";
            StringBuilder sbmarkers = new StringBuilder();
            //        if (hotel.Longitude != null && hotel.Latitude != null) {
            //            ViewData["HotelLatLng"] = string.Format("[{0},{1}]", Math.Round(hotel.Latitude.Value, 6).ToString(), Math.Round(hotel.Longitude.Value, 6).ToString());
            //            sbmarkers.Append("{");
            //            //string descr = hotel.Description.Length > 200 ?
            //            //                                hotel.Description.Substring(0, 200) + "<a href='../../ViewObject?id=" + hotel.Id + "'> Подробнее...</a>"
            //            //                                : hotel.Description;
            //            //descr = descr.Replace("\"", "&quot;");
            //            //descr = descr.Replace(Environment.NewLine, "");
            //            sbmarkers.Append(string.Format(
            //"lat: \"{0}\", lng:\"{1}\", options:{{icon: \"../../Content/images/flag_{2}.png\"}}, data:{{content: \"<strong>{3}</strong><br/><br/>{5}\", weblink_text: \"../../ViewObject?id={4}\"}}",
            //                                                Math.Round(hotel.Latitude.Value, 6).ToString(), Math.Round(hotel.Longitude.Value, 6).ToString(), "blue", hotel.Name, hotel.Id, string.Empty));//descr));
            //            sbmarkers.Append("}");
            //        }
            //        ViewData["MarkersHTML"] = sbmarkers.ToString();
            if (hotel.Longitude != null && hotel.Latitude != null) {
                ViewData["HotelLatLng"] = string.Format("[{0},{1}]", Math.Round(hotel.Latitude.Value, 6).ToString().Replace(',', '.').Replace(',', '.'), Math.Round(hotel.Longitude.Value, 6).ToString().Replace(',', '.'));
                sbmarkers.Append("{");
                string descr = hotel.Name;
                descr = descr.Replace("\"", "&quot;");
                descr = descr.Replace(Environment.NewLine, "");
                sbmarkers.Append(string.Format(
    "lat: \"{0}\", lng:\"{1}\", options:{{icon: \"../../Content/images/flag_{2}.png\"}}, data:{{content: \"{6}: <strong>{3}</strong><br/><br/>{5}\", weblink_text: \"#\"}}",
                                                    Math.Round(hotel.Latitude.Value, 6).ToString().Replace(',', '.'), Math.Round(hotel.Longitude.Value, 6).ToString().Replace(',', '.'), "red", hotel.Name, hotel.Id.ToString()
                                                    , descr
                                                    , "Отель"));
                sbmarkers.Append("}");
            }

            ViewData["MarkersHTML"] = sbmarkers.ToString();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public JsonResult SendTourBookMessage (string txtDlgItemId, string txtDlgUserName, string txtDlgEmail, string txtDlgFromDate, string txtDlgToDate, string txtDlgMessage) {
            TblTour tour = BizTour.GetTourById(int.Parse(txtDlgItemId));
            string subject = string.Format(Constants.MsgTourBookingSbjTemplate, txtDlgUserName, tour.Name);
            string body = string.Format(Constants.MsgTourBookingBodyTemplate, txtDlgUserName, txtDlgEmail, tour.Name, txtDlgFromDate, txtDlgToDate, txtDlgMessage);
            UIHelper.SendNotificationEmail(txtDlgEmail, subject, body);
            return Json(Constants.JSONPositiveResult);
        }

        public ActionResult SpecialOffers () {
            ViewData["GridList"] = GridSpecialOffersListHelper.GetOffersGridHTML();
            return View();
        }

        public ActionResult CountryExcurs () {
            //int id = int.Parse(Session["CountryId"].ToString());
            int id = int.Parse(Request.QueryString["id"].ToString());
            TblCountry country = BizCountry.GetCountryById(id);
            ViewData["CountryName"] = country.Name;
            ViewData["CountryId"] = country.Id;
            Session["CountryId"] = country.Id;
            ViewData["GridList"] = GridTourListHelper.GetTourGridHTML(BizTour.GetExcursListByCountryId(id));
            return View();
        }

        public ActionResult CountryCruises () {
            //int id = int.Parse(Session["CountryId"].ToString());
            int id = int.Parse(Request.QueryString["id"].ToString());
            TblCountry country = BizCountry.GetCountryById(id);
            ViewData["CountryName"] = country.Name;
            ViewData["CountryId"] = country.Id;
            Session["CountryId"] = country.Id;
            ViewData["GridList"] = GridTourListHelper.GetTourGridHTML(BizTour.GetCruiseListByCountryId(id));
            return View();
        }

        public ActionResult ViewTour () {
            int id = int.Parse(Request.QueryString["id"].ToString());
            List<TblRegion> regions = BizTour.GetTourRegionList(id);
            if (regions.Count > 0)
                BindCountryData(BizCountry.GetCountryById(regions[0].CountryId).Id);
            BindTourData(id);
            return View();
        }

        public ActionResult CountryAdditional () {
            int id = int.Parse(Request.QueryString["id"].ToString());
            BindCountryData(id);
            return View();
        }

        public ActionResult CountryArticles () {
            int? countryId = null;
            int regionId = Request.QueryString["regionid"] != null ? int.Parse(Request.QueryString["regionid"].ToString()) : 0;
            //List<TblSightseeing> sights = new List<TblSightseeing>();
            try {
                countryId = int.Parse(Request.QueryString["id"].ToString());
                ViewData["CountryId"] = countryId.Value;
                BindCountryData(countryId.Value);
                //if (regionId > 0)
                //    sights = BizSightseeing.GetSightseeingListByCountryIdRegionId(countryId.Value, regionId).OrderByDescending(p => p.Id).ToList();
                //else
                //    sights = BizSightseeing.GetSightseeingListByCountryId(countryId.Value).OrderByDescending(p => p.Id).ToList();
                //ViewData["ArticleCount"] = sights.Count;
            } catch {
                //sights = BizSightseeing.GetSightseeingList();
            }
            ViewData["ddlCountryArticle"] = new SelectList(DictionaryHelper.GetCountryListData(true).ToList(), "Id", "Name", countryId.HasValue
                                                                        ? countryId.Value : Constants.NoValueSelected);
            //ViewData["ddlDistrict"] = new SelectList(DictionaryHelper.GetDistrictListWithArticlesByCountryId(id).ToList(), "Id", "Name"
            //                                                                                        , regionId > 0 ? regionId : Constants.NoValueSelected);
            //ViewData["GridArticleList"] = GridArticleList.GetGridHTML(sights, countryId, false);
            return View();
        }

        public ActionResult ViewByTag () {
            ViewData["TagName"] = Request.QueryString["tag"].ToString();
            ViewData["CountryId"] = Request.QueryString["countryId"].ToString();
            Session["CountryId"] = Request.QueryString["countryId"].ToString();
            int? countryId = null;
            try {
                countryId = int.Parse(ViewData["CountryId"].ToString());
            } catch { countryId = null; }

            ViewData["GridArticleList"] = GridArticleList.GetGridHTML(BizSightseeing.GetSightseeingList(ViewData["TagName"].ToString()), countryId, false);
            return View();
        }

        public ActionResult CountryAbout () {
            try {
                int id = int.Parse(Request.QueryString["id"].ToString());
                TblCountry country = BizCountry.GetCountryById(id);
                ViewData["CountryName"] = country.Name;
                ViewData["CountryId"] = country.Id;
                ViewData["Description"] = country.Description;
                ViewData["AdditionalInfo"] = country.AdditionalInfo;
                ViewData["VisaInfo"] = country.VisaInfo;
                ViewData["RegionCityListHTML"] = BindCountryRegionCityList(country.Id);
                ViewData["MarkersCityListHTML"] = BindMapCountryMarkers(country.Id);
                //List<TblSightseeing> sights = BizSightseeing.GetSightseeingListByCountryId(id).OrderByDescending(p => p.Id).Take(5).ToList();
                //ViewData["ArticleCount"] = sights.Count;
                //ViewData["GridArticleList"] = Elcondor.UI.Utilities.GridArticleList.GetGridHTML(sights, id, true);
                List<TblCity> cities = BizCity.GetCityListByCountryId(country.Id);
                BindCountryRegionCityList(country.Id);
                if (cities.Count > 0) {
                    TblCity capital = BizCity.GetCapitalCity(country.Id);
                    if (capital == null || string.IsNullOrEmpty(capital.Latitude) || string.IsNullOrEmpty(capital.Longitude)) {
                        foreach (TblCity cty in cities) {
                            if (!string.IsNullOrEmpty(cty.Latitude) && !string.IsNullOrEmpty(cty.Longitude))
                                capital = cty;
                        }
                    }
                    ViewData["CapitalLatLng"] = capital == null ? "[0,0]" : string.Format("[{0},{1}]", capital.Latitude, capital.Longitude);
                }
                Session["CountryId"] = country.Id;
                List<TblCountryInfo> listCountryInfo = BizCountry.GetCountryInfoList(country.Id);
                ViewData["GridCountryInfo"] = UI.Utilities.GridCountryInfoList.GetGridHTML(listCountryInfo, true);
                ViewData["CountryInfoContents"] = UI.Utilities.GridCountryInfoList.GetContentsHTML(listCountryInfo);
                return View();
            } catch {
                List<TblCountryAll> cntries = BizDictionary.GetCountryAllInfo();
                if (cntries.Count > 0)
                    Response.Redirect(string.Format("/CountryAbout?id={0}", cntries[0].Id.ToString()));
                else
                    Response.Redirect("/Index");
            }
            return View();
        }

        public ActionResult RegionAbout () {
            int id = int.Parse(Request.QueryString["id"].ToString());
            TblRegion reg = BizRegion.GetRegionById(id);
            TblCountry country = BizCountry.GetCountryById(reg.CountryId);
            ViewData["CountryName"] = country.Name;
            ViewData["CountryId"] = country.Id;
            ViewData["RegionName"] = reg.Name;
            ViewData["RegionId"] = reg.Id;
            ViewData["Description"] = reg.Description;
            Session["CountryId"] = reg.CountryId;

            ViewData["RegLatLng"] = "[0,0]";
            StringBuilder sbmarkers = new StringBuilder();
            if (reg.Longitude != null || reg.Latitude != null) {
                ViewData["RegLatLng"] = string.Format("[{0},{1}]", reg.Latitude, reg.Longitude);
                sbmarkers.Append("{");
                string descr = reg.Description.Length > 200 ?
                                                reg.Description.Substring(0, 200) + "<a href='../../RegionAbout?id=" + reg.Id + "'> Подробнее...</a>"
                                                : reg.Description;
                descr = descr.Replace("\"", "&quot;");
                descr = descr.Replace(Environment.NewLine, "");
                sbmarkers.Append(string.Format(
    "lat: \"{0}\", lng:\"{1}\", options:{{icon: \"../../Content/images/flag_{2}.png\"}}, data:{{content: \"<strong>{3}</strong><br/><br/>{5}\", weblink_text: \"../../RegionAbout?id={4}\"}}",
                                                    reg.Latitude, reg.Longitude, "blue", reg.Name, reg.Id, descr));
                sbmarkers.Append("}");
            }
            ViewData["MarkersRegListHTML"] = sbmarkers.ToString();
            return View();
        }

        public ActionResult RegionRecreationAbout () {
            int id = int.Parse(Request.QueryString["id"].ToString());
            TblRegionRecreation regrec = BizRegionRecreation.GetRegionRecreationById(id);
            TblRegion reg = BizRegion.GetRegionById(regrec.RegionId);
            TblCountry country = BizCountry.GetCountryById(reg.CountryId);
            ViewData["CountryName"] = country.Name;
            ViewData["CountryId"] = country.Id;
            ViewData["RegionName"] = reg.Name;
            ViewData["RegionId"] = reg.Id;
            ViewData["Description"] = regrec.Description;
            ViewData["RecreationName"] = regrec.Name;
            ViewData["RegionRecreationId"] = regrec.Id;
            Session["CountryId"] = reg.CountryId;
            return View();
        }

        public ActionResult CityAbout () {
            int id = int.Parse(Request.QueryString["id"].ToString());
            TblCity city = BizCity.GetCityById(id);
            TblCountry country = BizCountry.GetCountryById(city.CountryId);
            ViewData["CityName"] = city.Name;
            ViewData["CityDescription"] = city.Description;
            ViewData["CountryName"] = country.Name;
            ViewData["CountryId"] = country.Id;
            ViewData["RegionName"] = BizRegion.GetRegionById(city.RegionId).Name;
            ViewData["RegionId"] = city.RegionId;
            ViewData["CityId"] = city.Id;
            ViewData["CityIsBeach"] = city.IsBeach;
            ViewData["CityLatLng"] = city.Longitude == null || city.Latitude == null ? "[0,0]" : string.Format("[{0},{1}]", city.Latitude, city.Longitude);
            Session["CountryId"] = country.Id;
            StringBuilder sbmarkers = new StringBuilder();
            if (city.Longitude != null || city.Latitude != null) {
                sbmarkers.Append("{");
                string descr = city.Description.Length > 200 ?
                                                city.Description.Substring(0, 200) + "<a href='../../CityAbout?id=" + city.Id + "'> Подробнее...</a>"
                                                : city.Description;
                descr = descr.Replace("\"", "&quot;");
                descr = descr.Replace(Environment.NewLine, "");
                sbmarkers.Append(string.Format(
    "lat: \"{0}\", lng:\"{1}\", options:{{icon: \"../../Content/images/flag_{2}.png\"}}, data:{{content: \"{6}: <strong>{3}</strong><br/><br/>{5}\", weblink_text: \"../../CityAbout?id={4}\"}}",
                                                    city.Latitude, city.Longitude, city.IsCapital ? "red" : "blue", city.Name, city.Id.ToString()
                                                    , descr
                                                    , city.IsCapital ? "Столица" : "Город"));
                sbmarkers.Append("}");
            }

            ViewData["MarkersCityListHTML"] = sbmarkers.ToString();
            return View();
        }

        public ActionResult Contacts () {
            TblPage page = BizDictionary.GetPageById(Constants.PageContactsId);
            ViewData["PageTitle"] = page.Title;
            ViewData["PageContent"] = page.Text;
            return View();
        }

        public ActionResult MyAccount () {
            TblPage page = BizDictionary.GetPageById(Constants.PageMyAccountId);
            ViewData["PageTitle"] = page.Title;
            ViewData["PageContent"] = page.Text;

            return View();
        }

        public ActionResult News () {
            TblPage page = BizDictionary.GetPageById(Constants.PageNewsId);
            ViewData["PageTitle"] = page.Title;
            ViewData["PageContent"] = page.Text;

            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult VisaInfo (string txtName, string txtPrevName, string txtHusbandName, string txtAddress, string txtPhone, string txtEmail, string txtJob, string txtCitiesVisited, string lastvisitdatefrom, string lastvisitdateto, string visitdatefrom, string txtVisitCityName,
            string txtNumberOfEntries, string txtVisitedCountryList, string txtGarantInRF, string txtFIO, string txtPersPhone) {
            if (this.IsCaptchaVerify("Неверно указан код с картинки.")) {
                TempData["Message"] = "Message: captcha is valid.";
                //return View();
            }
            if (ValidateVisaInfo(txtName, txtPrevName, txtHusbandName, txtAddress, txtPhone, txtEmail, txtJob, txtCitiesVisited, lastvisitdatefrom, lastvisitdateto, visitdatefrom, txtVisitCityName, txtNumberOfEntries, txtVisitedCountryList, txtGarantInRF, txtFIO, txtPersPhone)) {
                UIHelper.SendNotificationEmail(Constants.MsgAdminEmailAddress, string.Format(Constants.MsgGoaVisaAnketaSubjTemplate, txtName), string.Format(Constants.MsgGoaVisaAnketaBodyTemplate, txtName, txtPrevName, txtHusbandName, txtAddress, txtPhone, txtEmail, txtJob, txtCitiesVisited, lastvisitdatefrom, lastvisitdateto, visitdatefrom, txtVisitCityName, txtNumberOfEntries, txtVisitedCountryList, txtGarantInRF, txtFIO, txtPersPhone));
                Response.Redirect("/MessageSent");
            }
            TempData["ErrorMessage"] = "Error: captcha is not valid.";
            TblPage page = BizDictionary.GetPageById(Constants.PageVisaInfoId);
            ViewData["PageTitle"] = page.Title;
            ViewData["PageContent"] = page.Text;

            return View();
        }

        public ActionResult VisaInfo () {
            TblPage page = BizDictionary.GetPageById(Constants.PageVisaInfoId);
            ViewData["PageTitle"] = page.Title;
            ViewData["PageContent"] = page.Text;
            return View();
        }

        public ActionResult ViewNews () {
            int id = int.Parse(Request.QueryString["id"].ToString());
            BindNewsData(id);
            return View();
        }

        public ActionResult Page () {
            int id = int.Parse(Request.QueryString["id"].ToString());
            TblPage page = BizDictionary.GetPageById(id);
            ViewData["PageTitle"] = page.Title;
            ViewData["PageContent"] = page.Text;

            return View();
        }

        public ActionResult HotTours () {
            ViewData["GridList"] = GridTourListHelper.GetTourGridHTML(BizTour.GetExcursListByCountryId(null));
            return View();
        }

        public ActionResult UserHome () {
            return View();
        }

        public ActionResult FlightTickets () {
            try {
                int routeId = int.Parse(Request.QueryString["routeId"].ToString());
                //ViewData["GridFlightListHTML"] = GridFlightListHelper.GetFlightGridHTML(routeId);
                ViewData["RouteId"] = routeId;
                TblRoute rt = BizFlight.GetRouteById(routeId);
                ViewData["RouteName"] = rt.Name;
                ViewData["GridRouteFlights"] = GridFlightListHelper.GetRouteFlightHTML(routeId);
            } catch {
                //ViewData["GridCharterRouteListHTML"] = GridFlightListHelper.GetRouteGridHTML();
                ViewData["GridRouteFlights"] = GridFlightListHelper.GetRouteFlightHTML();
            }
            ViewData["ddlRoutes"] = new SelectList(DictionaryHelper.GetRouteListData(true).ToList(), "Id", "Name", Constants.NoValueSelected);
            TblPage page = BizDictionary.GetPageById(Constants.PageAviaId);
            ViewData["FlightInfo"] = page.Text;
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult FlightTickets (string txtCityFrom, string txtCityTo, string txtFlightDate) {


            return View();
        }

        private DateTime BindSightseeingData (int id) {
            TblSightseeing sightseeing = BizSightseeing.GetSightseeingById(id);
            ViewData["ArticleName"] = sightseeing.Name;
            ViewData["ArticleContents"] = sightseeing.Description;
            ViewData["ArticleDate"] = sightseeing.DateCreated;
            ViewData["ArticleId"] = sightseeing.Id;
            ViewData["CountryId"] = sightseeing.CountryId;
            ViewData["CountryName"] = BizCountry.GetCountryById(sightseeing.CountryId).Name;
            ViewData["ShortDescription"] = sightseeing.ShortDescription;
            BindSightseeingRegionData(BizTour.GetTourRegionList(id));
            //if (sightseeing.RegionId != Constants.NoValueSelected)
            //    BindRegionData(sightseeing.RegionId);
            //else
            //    BindCountryData(sightseeing.CountryId.Value);
            return sightseeing.DateCreated.Value;
        }

        private void BindCountryData (int countryId) {
            TblCountry country = BizCountry.GetCountryById(countryId);
            ViewData["CountryName"] = country.Name;
            ViewData["AdditionalInfo"] = country.AdditionalInfo;
            ViewData["CountryId"] = country.Id;
            Session["CountryId"] = country.Id;
            ViewData["Description"] = country.Description;
            ViewData["VisaDescription"] = country.VisaInfo;
            ViewData["ddlCity"] = new SelectList(BizCity.GetCityListByCountryId(country.Id), "Id", "Name", Constants.NoValueSelected);
            TblCity cap = BizCity.GetCapitalCity(country.Id);
            if (cap != null)
                ViewData["CountryCapitalName"] = cap.Name;
        }

        private TblTour BindTourData (int id) {
            TblTour tour = BizTour.GetTourById(id);
            ViewData["TourName"] = tour.Name;
            if (tour.Price.HasValue)
                ViewData["TourPrice"] = tour.Price;
            ViewData["PhotoCount"] = BizTour.GetImageGallery(tour.Id).Count;
            ViewData["TourProgram"] = tour.ProgramDescription;
            ViewData["TourId"] = tour.Id;
            ViewData["TourDescription"] = tour.Description;
            Session["TourId"] = tour.Id;
            return tour;
        }

        private void BindTourRegionData (List<TblRegion> regs) {
            if (regs.Count > 0)
                ViewData["CountryName"] = BizCountry.GetCountryById(regs[0].CountryId).Name;

            StringBuilder sb = new StringBuilder();
            foreach (TblRegion itm in regs)
                sb.Append(string.Format("{0}, ", itm.Name));
            if (sb.Length > 0)
                ViewData["TourRegionNames"] = sb.ToString().Substring(0, sb.Length - 2);
            Session["RegionIds"] = regs;
        }

        private void BindSightseeingRegionData (List<TblRegion> regs) {
            if (regs.Count > 0)
                ViewData["CountryName"] = BizCountry.GetCountryById(regs[0].CountryId).Name;
            StringBuilder sb = new StringBuilder();
            foreach (TblRegion itm in regs)
                sb.Append(string.Format("{0}, ", itm.Name));
            if (sb.Length > 0)
                ViewData["SightseeingRegionNames"] = sb.ToString().Substring(0, sb.Length - 2);
            else
                ViewData["SightseeingRegionNames"] = ViewData["CountryName"];
            Session["SightseeingRegionIds"] = regs;
        }

        private void BindRegionData (int id) {
            TblRegion reg = BizRegion.GetRegionById(id);
            TblCountry country = BizCountry.GetCountryById(reg.CountryId);
            ViewData["CountryId"] = country.Id;
            ViewData["CountryName"] = BizCountry.GetCountryById(reg.CountryId).Name;
            ViewData["RegionName"] = reg.Name;
            ViewData["RegionId"] = reg.Id;
            ViewData["Description"] = reg.Description;
            Session["RegionId"] = reg.Id;
        }

        private string BindCountryRegionCityList (int countryId) {
            StringBuilder sb1 = new StringBuilder();
            int i = 0;
            TblCity capital = BizCity.GetCapitalCity(countryId);
            if (capital != null) {
                TblRegion capregn = BizRegion.GetRegionById(capital.RegionId);
                sb1.Append(string.Format(
"<a href=\"../../CityAbout?id={0}\" id=\"cty{0}\"><b>{1}</b> </a>"
                    , capital.Id, capital.Name));
            }

            foreach (LinqToElcondor.TblRegion regn in DictionaryHelper.GetDistrictListData(int.Parse(ViewData["CountryId"].ToString()))) {
                if (capital == null || regn.Id != capital.RegionId) {
                    sb1.Append(string.Format(
    "<a href=\"../../RegionAbout?id={0}\" id=\"regn{0}\" style=\"text-decoration: none;font-weight:normal;\">&nbsp;{1}</a> : "
                        , regn.Id, regn.Name.ToUpper()));
                    i++;
                    foreach (LinqToElcondor.TblCity cty in DictionaryHelper.GetCityListData(regn.Id)) {
                        sb1.Append(string.Format(
    "&nbsp; <a href=\"../../CityAbout?id={0}\" style=\"text-decoration: none;font-weight:normal;\" id=\"cty{0}\">{1} </span></a>"
                        , cty.Id, cty.Name));
                    }
                    //            List<TblCity> beaches = DictionaryHelper.GetBeachListData(regn.Id);
                    //            if (beaches.Count() > 0) {
                    //                sb1.Append(" Пляжи: ");
                    //                foreach (LinqToElcondor.TblCity cty in beaches) {
                    //                    sb1.Append(string.Format(
                    //"&nbsp; <a href=\"../../CityAbout?id={0}\" style=\"text-decoration: none;font-weight:normal;\" id=\"cty{0}\">{1} </span></a>"
                    //                    , cty.Id, cty.Name));
                    //                }
                    //            }
                }
            }
            return sb1.ToString();
        }

        private string BindMapCountryMarkers (int countryId) {
            StringBuilder sbmarkers = new StringBuilder();
            if (ElcondorBiz.BizCity.GetCityListByCountryId(countryId).Count > 0) {
                foreach (LinqToElcondor.TblRegion reg in Elcondor.UI.Utilities.DictionaryHelper.GetDistrictListData(countryId)) {
                    foreach (LinqToElcondor.TblCity city in Elcondor.UI.Utilities.DictionaryHelper.GetCityListData(reg.Id)) {
                        if (!string.IsNullOrEmpty(city.Latitude) && !string.IsNullOrEmpty(city.Longitude)) {
                            sbmarkers.Append("{");
                            string descr = city.Description.Length > 200 ?
                                            city.Description.Substring(0, 200) + "<a href='../../CityAbout?id=" + city.Id + "'> Подробнее...</a>"
                                            : city.Description;
                            descr = descr.Replace("\"", "&quot;");
                            descr = descr.Replace(Environment.NewLine, "");
                            sbmarkers.Append(string.Format(
"lat: \"{0}\", lng:\"{1}\", options:{{icon: \"../../Content/images/flag_{2}.png\"}}, data:{{content: \"{6}: <strong>{3}</strong><br/><br/>{5}\", weblink_text: \"../../CityAbout?id={4}\"}}",
                                                city.Latitude, city.Longitude, city.IsCapital ? "red" : "blue", city.Name, city.Id.ToString()
                                                , descr
                                                , city.IsCapital ? "Столица" : "Город"));
                            sbmarkers.Append("},");
                        }
                    }
                }
                if (sbmarkers.Length > 0)
                    sbmarkers.Remove(sbmarkers.Length - 1, 1);

            }
            return sbmarkers.ToString();
        }

        public bool ValidateVisaInfo (string txtName, string txtPrevName, string txtHusbandName, string txtAddress, string txtPhone, string txtEmail, string txtJob, string txtCitiesVisited, string lastvisitdatefrom, string lastvisitdateto, string visitdatefrom, string txtVisitCityName,
            string txtNumberOfEntries, string txtVisitedCountryList, string txtGarantInRF, string txtFIO, string personalPhone) {
            if (String.IsNullOrEmpty(txtFIO)) {
                ModelState.AddModelError("txtFIO", "Укажите Ваше имя.");
            }
            if (String.IsNullOrEmpty(personalPhone)) {
                ModelState.AddModelError("personalPhone", "Укажите телефон.");
            }
            if (String.IsNullOrEmpty(txtName)) {
                ModelState.AddModelError("txtName", "Укажите ФИО отца, матери, где они родились.");
            }
            if (String.IsNullOrEmpty(txtPrevName)) {
                ModelState.AddModelError("txtPrevName", "Укажите Предыдущие фамилии или впишите \"Нет\".");
            }
            if (String.IsNullOrEmpty(txtHusbandName)) {
                ModelState.AddModelError("txtHusbandName", "Укажите ФИО мужа/жены или впишите \"Нет\".");
            }
            if (String.IsNullOrEmpty(txtAddress)) {
                ModelState.AddModelError("txtAddress", "Укажите адрес.");
            }
            if (String.IsNullOrEmpty(txtPhone)) {
                ModelState.AddModelError("txtPhone", "Укажите телефон.");
            }
            if (String.IsNullOrEmpty(txtEmail)) {
                ModelState.AddModelError("txtEmail", "Укажите емейл.");
            }
            if (String.IsNullOrEmpty(txtJob)) {
                ModelState.AddModelError("txtJob", "Укажите Место работы.");
            }
            if (String.IsNullOrEmpty(txtCitiesVisited)) {
                ModelState.AddModelError("txtCitiesVisited", "Укажите Города в Индии, которые Вы посетили.");
            }
            IFormatProvider culture = new CultureInfo("fr-Fr", true);
            if (String.IsNullOrEmpty(lastvisitdatefrom)) {
                ModelState.AddModelError("lastvisitdatefrom", "Укажите Дату начала последнего визита.");
            } else {
                try { DateTime.ParseExact(lastvisitdatefrom, "dd/MM/yyyy", culture, DateTimeStyles.NoCurrentDateDefault); } catch { ModelState.AddModelError("lastvisitdatefrom", "Дата начала последнего визита указана неверно."); }
            }
            if (String.IsNullOrEmpty(lastvisitdateto)) {
                ModelState.AddModelError("lastvisitdateto", "Укажите Дату конца последнего визита.");
            } else {
                try { DateTime.ParseExact(lastvisitdateto, "dd/MM/yyyy", culture, DateTimeStyles.NoCurrentDateDefault); } catch { ModelState.AddModelError("lastvisitdateto", "Дата конца последнего визита указана неверно."); }
            }
            if (String.IsNullOrEmpty(visitdatefrom)) {
                ModelState.AddModelError("visitdatefrom", "Укажите Дату прибытия в Индию.");
            } else {
                try { DateTime.ParseExact(visitdatefrom.Replace(".", "/"), "dd/MM/yyyy", culture, DateTimeStyles.NoCurrentDateDefault); } catch { ModelState.AddModelError("visitdatefrom", "Дата прибытия в Индию указана неверно."); }
            }
            if (String.IsNullOrEmpty(lastvisitdateto)) {
                try {
                    DateTime start = DateTime.ParseExact(lastvisitdatefrom, "dd/MM/yyyy", culture, DateTimeStyles.NoCurrentDateDefault);
                    DateTime end = DateTime.ParseExact(lastvisitdateto, "dd/MM/yyyy", culture, DateTimeStyles.NoCurrentDateDefault);
                    if (start > end)
                        ModelState.AddModelError("lastvisitdateto", "Дата конца последнего визита не может быть раньше даты начала.");
                } catch {
                    ModelState.AddModelError("lastvisitdateto", "Дата конца последнего визита указана неверно.");
                }
            }
            if (String.IsNullOrEmpty(txtVisitCityName)) {
                ModelState.AddModelError("txtVisitCityName", "Укажите Город прибытия .");
            }
            if (String.IsNullOrEmpty(txtNumberOfEntries)) {
                ModelState.AddModelError("txtNumberOfEntries", "Укажите Количество въездов.");
            }
            if (String.IsNullOrEmpty(txtVisitedCountryList)) {
                ModelState.AddModelError("txtVisitedCountryList", "Укажите Страны , которые Вы посетили в течение 10 лет.");
            }
            if (String.IsNullOrEmpty(txtGarantInRF)) {
                ModelState.AddModelError("txtGarantInRF", "Укажите Гаранта в Российской федерации.");
            }
            return ModelState.IsValid;
        }

        private void BindNewsData (int id) {
            TblNews itm = BizNews.GetNewsById(id);
            ViewData["NewsId"] = itm.Id;
            ViewData["NewsDate"] = itm.DateCreated.ToString("dd.MM.yyyy");
            ViewData["NewsTitle"] = itm.Title;
            ViewData["NewsDesc"] = itm.Description;
            bool hasThumbImage = false;
            try {
                hasThumbImage = itm.ThumbImage.Length > 0;
            } catch { hasThumbImage = false; }
            ViewData["NewsHasThumbImage"] = hasThumbImage;
            bool hasLargeImage = false;
            try {
                hasLargeImage = itm.LargeImage.Length > 0;
            } catch { hasLargeImage = false; }
            ViewData["NewsHasLargeImage"] = hasLargeImage;
        }

        public bool ValidateNewMessage (string txtSubject, string txtMessageBody) {
            if (String.IsNullOrEmpty(txtSubject)) {
                ModelState.AddModelError("txtSubject", "Укажите тему.");
            } else if (txtSubject.Length >= 500) {
                ModelState.AddModelError("txtSubject", "Поле Тема не может содержать более 500 символов.");
            }
            if (String.IsNullOrEmpty(txtMessageBody)) {
                ModelState.AddModelError("txtMessageBody", "Введите текст сообщения.");
            } else if (txtMessageBody.Length >= 2000) {
                ModelState.AddModelError("txtMessageBody", "Поле Сообщение не может содержать более 2000 символов.");
            }
            return ModelState.IsValid;
        }

        public bool ValidateSearchParams (string txtCountries, string datefrom, string dateto, string adults, string kids) {
            if (String.IsNullOrEmpty(dateto)) {
                ModelState.AddModelError("txtCountries", "Выберите страну.");
            }
            IFormatProvider culture = new CultureInfo("ru-RU", true);
            if (String.IsNullOrEmpty(datefrom)) {
                ModelState.AddModelError("datefrom", "Введите дату отъезда.");
            } else {
                try {
                    DateTime start = DateTime.ParseExact(datefrom, "dd/MM/yyyy", culture, DateTimeStyles.NoCurrentDateDefault);
                } catch {
                    ModelState.AddModelError("datefrom", "Дата отъезда указана неверно.");
                }
            }
            if (String.IsNullOrEmpty(dateto)) {
                ModelState.AddModelError("datefrom", "Введите дату приезда.");
            } else {
                try {
                    DateTime start = DateTime.ParseExact(datefrom, "dd/MM/yyyy", culture, DateTimeStyles.NoCurrentDateDefault);
                    DateTime end = DateTime.ParseExact(dateto, "dd/MM/yyyy", culture, DateTimeStyles.NoCurrentDateDefault);
                    if (start > end)
                        ModelState.AddModelError("dateto", "Дата возврата не может быть раньше даты отъезда.");
                } catch {
                    ModelState.AddModelError("dateto", "Дата возврата указана неверно.");
                }
            }
            if (String.IsNullOrEmpty(adults)) {
                ModelState.AddModelError("adults", "Укажите количество взрослых.");
            } else {
                try {
                    int.Parse(adults);
                } catch {
                    ModelState.AddModelError("adults", "Количество взрослых указано неверно.");
                }
            }
            if (String.IsNullOrEmpty(kids)) {
                ModelState.AddModelError("kids", "Укажите количество детей.");
            } else {
                try {
                    int.Parse(kids);
                } catch {
                    ModelState.AddModelError("kids", "Количество детей указано неверно.");
                }
            }
            return ModelState.IsValid;
        }

        public bool ValidateHotelBooking (string txtName, string txtPersPhone, string datefrom, string dateto) {
            if (String.IsNullOrEmpty(txtName)) {
                ModelState.AddModelError("txtName", "Укажите фамилию, имя и отчество.");
            }
            if (String.IsNullOrEmpty(txtPersPhone)) {
                ModelState.AddModelError("txtPersPhone", "Укажите телефон.");
            }
            IFormatProvider culture = new CultureInfo("ru-RU", true);
            if (String.IsNullOrEmpty(datefrom)) {
                ModelState.AddModelError("datefrom", "Введите дату отъезда.");
            } else {
                try {
                    DateTime start = DateTime.ParseExact(datefrom, "dd/MM/yyyy", new CultureInfo("ru-RU", true), DateTimeStyles.NoCurrentDateDefault);
                } catch {
                    ModelState.AddModelError("datefrom", "Дата отъезда указана неверно.");
                }
            }
            if (String.IsNullOrEmpty(dateto)) {
                ModelState.AddModelError("datefrom", "Введите дату приезда.");
            } else {
                try {
                    DateTime start = DateTime.ParseExact(datefrom, "dd/MM/yyyy", culture, DateTimeStyles.NoCurrentDateDefault);
                    DateTime end = DateTime.ParseExact(dateto, "dd/MM/yyyy", culture, DateTimeStyles.NoCurrentDateDefault);
                    if (start > end)
                        ModelState.AddModelError("dateto", "Дата возврата не может быть раньше даты отъезда.");
                } catch {
                    ModelState.AddModelError("dateto", "Дата возврата указана неверно.");
                }
            }
            return ModelState.IsValid;
        }
    }
}
