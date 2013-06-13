using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Threading;
using System.Text;
using TaratripLinq;
using System.IO;
using System.Drawing;
using TaratripBiz;
using Elcondor.Models;
using Elcondor.Utilities;
using Elcondor.UI.Utilities;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using Elcondor;

namespace Elcondor {
    /// <summary>
    /// Summary description for TaratripWS
    /// </summary>
    [WebService(Namespace = "../../")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [System.Web.Script.Services.ScriptService] 
    public class TaratripWS : System.Web.Services.WebService {
        [WebMethod]
        public string GetHotelViewByIdHTML(string hotelId) {
            return HotelViewPopupHelper.GetHotelViewPopupHTML(int.Parse(hotelId));
        }

        [WebMethod]
        public string GetHotelPhotoCount(string hotelId) {
            return BizHotel.GetHotelImageGallery(int.Parse(hotelId)).Count.ToString();
        }

        [WebMethod]
        public string GetHotelGalleryViewByIdHTML(string hotelId) {
            return HotelViewPopupHelper.GetHotelGalleryViewByIdHTML(int.Parse(hotelId));
        }

        [WebMethod]
        public string GetHotelImagesHTML(string hotelId) {
            return HotelImageHelper.GetHotelImagesHTML(int.Parse(hotelId), false);
        }

        [WebMethod]
        public string GetHotelSearchResult(NameValue[] formVars) {
            return GridHotelSearchResult.GetGridHotelSearchGridHTML(FillHotelSearchParameter(formVars));
        }
        
        private static HotelSearchParameter FillHotelSearchParameter(NameValue[] formVars) {
            List<int> ddlAccomodationTypesList = new List<int>();
            List<int> goodForPersonList = new List<int>();
            string accomodationTypeValues = HttpUtility.HtmlEncode(formVars.Form("ddlAccomodationType"));
            string goodForPersonValues = HttpUtility.HtmlEncode(formVars.Form("ddlGoodForPerson"));
            if (accomodationTypeValues != Constants.JSONNullElementValue) {
                foreach (string str in accomodationTypeValues.Split(','))
                    ddlAccomodationTypesList.Add(int.Parse(str));
            }
            if (goodForPersonValues != Constants.JSONNullElementValue) {
                foreach (string str in goodForPersonValues.Split(','))
                    goodForPersonList.Add(int.Parse(str));
            }
            int? id = null;
            int? districtId = null; 
            int? countryId = null; 
            int? cityId = null; 
            int? distanceToBeach = null; 
            int? starRating = null; 
            int? maxPeople = null; 
            float? minPrice = null; 
            float? maxPrice = null;
            int currencyId = 1;
            try { currencyId = int.Parse(HttpUtility.HtmlEncode(formVars.Form("ddlCurrency"))); } catch { }
            try {id = int.Parse(HttpUtility.HtmlEncode(formVars.Form("txtHotelId")));} catch {}
            try {districtId = int.Parse(HttpUtility.HtmlEncode(formVars.Form("ddlDistrict")));} catch {}
            try {countryId = int.Parse(HttpUtility.HtmlEncode(formVars.Form("ddlCountry")));} catch {}
            try {cityId = int.Parse(HttpUtility.HtmlEncode(formVars.Form("ddlCity")));} catch {}
            try { distanceToBeach = int.Parse(HttpUtility.HtmlEncode(formVars.Form("ddlDistanceToSea"))); } catch { }
            try {starRating = int.Parse(HttpUtility.HtmlEncode(formVars.Form("hdnStarRatingChoice")));} catch {}
            try {minPrice = float.Parse(HttpUtility.HtmlEncode(formVars.Form("txtPriceStart")));} catch {}
            try {maxPrice = float.Parse(HttpUtility.HtmlEncode(formVars.Form("txtPriceEnd")));} catch {}

            HotelSearchParameter param = new HotelSearchParameter(id
                                    , HttpUtility.HtmlEncode(formVars.Form("txtHotelName"))
                                    , districtId.HasValue ? (districtId.Value == -1 ? null : districtId) : null
                                    , countryId.HasValue ? (countryId.Value == -1 ? null : countryId) : null
                                    , cityId.HasValue ? (cityId.Value == -1 ? null : cityId) : null 
                                    , distanceToBeach.HasValue ? (distanceToBeach.Value == -1 ? null : distanceToBeach) : null
                                    , starRating.HasValue ? (starRating.Value == -1 ? null : starRating) : null
                                    , maxPeople, minPrice, maxPrice
                                    , ddlAccomodationTypesList, goodForPersonList, currencyId);
            return param;
        }
        
        #region Dictionaries

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json, XmlSerializeString = false, UseHttpGet = true)]
        public string GetCountryList() {
            return BizDictionary.GetCountryList();
        }

        [WebMethod]
        public string GetCurrencyList() {
            return BizDictionary.GetCurrencyList(); ;
        }

        [WebMethod]
        public string GetDistrictList(int countryId) {
            return BizDictionary.GetDistrictList(countryId); ;
        }

        [WebMethod]
        public string GetCityListByCountry(int countryId) {
            return BizDictionary.GetCityListByCountry(countryId); ;
        }

        [WebMethod]
        public string GetCityListByDistrict(int districtId) {
            return BizDictionary.GetCityListByDistrict(districtId); ;
        }

        [WebMethod]
        public string GetAccomodationTypeList() {
            return BizDictionary.GetAccomodationTypeList();
        }

        [WebMethod]
        public string GetHotelStatusList() {
            return BizDictionary.GetHotelStatusList();
        }
        
        [WebMethod]
        public string GetGoodForPersonList() {
            return BizDictionary.GetGoodForPersonList();
        }

        #endregion Dictionaries

        [WebMethod]
        public string GetStarRatingControl(int hotelId) {
            int starAmount = BizHotel.GetStarAmount(hotelId);
            return string.Empty;//Models.StarRatingControlHelper.GetHotelStarRatingHTML(starAmount); ;
        }
    }
}
