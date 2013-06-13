using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Threading;
using LinqToElcondor;
using System.IO;
using System.Drawing;
using ElcondorBiz;
using Elcondor.Models;
using Elcondor.UI.Utilities;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web;
using System.Web.Services;
using Microsoft.Ajax.Samples;
using System.Text.RegularExpressions;
using System.Xml;

namespace Elcondor {
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class ElcondorWCF : IElcondorWCF {
        public string GetWeatherInfo (string cityName) {
            WebserviceX.GlobalWeatherSoapClient client = new WebserviceX.GlobalWeatherSoapClient("GlobalWeatherSoap");
            //client.GetWeather(cityName, string.Empty);
            string weather = client.GetWeather(cityName, string.Empty);
            //return (new JavaScriptSerializer()).Serialize(weather);
            return weather;
        }

        public string GetLocaltime (double offset) {
            return DateTime.UtcNow.AddHours(offset).ToString("HH:mm");
        }

        public string GetCountryGMTOffset (string countryName) {
            WebserviceXCountry.countrySoapClient ws = new WebserviceXCountry.countrySoapClient("countrySoap");
            XmlDocument xml = new XmlDocument();
            xml.LoadXml(ws.GetGMTbyCountry(countryName));
            XmlNodeList xnList = xml.SelectNodes("/NewDataSet/Table");
            string gmt = string.Empty;
            foreach (XmlNode xn in xnList) {
                gmt = xn["GMT"].InnerText;
            }
            return gmt;
        }

        public string GetRusEngTranslation (string countryNameRus) {
            return string.Empty;
        }

        #region Dictionaries

        public string GetCountryListJS() {
            return BizDictionary.GetCountryListJS();
        }

        public string GetDistrictListJS(int countryId) {
            return BizDictionary.GetDistrictListJS(countryId); 
        }

        public string GetDistrictListWithArticlesByCountryIdJS (int countryId) {
            return BizDictionary.GetDistrictListWithArticlesByCountryIdJS(countryId);
        }
        
        public string GetCountryListWithToursJS (int countryId) {
            return BizDictionary.GetCountryListWithToursJS(countryId);
        }

        public string GetCityListByCountryJS(int countryId) {
            return BizDictionary.GetCityListByCountryJS(countryId); 
        }

        public string GetCityListByDistrictJS(int RegionId) {
            return BizDictionary.GetCityListByDistrictJS(RegionId); 
        }

        public string GetSightseeingTypeListJS () {
            return BizDictionary.GetSightseeingTypeListJS();
        }

        public string GetRegionRecreationDescr (int regionRecreationId) {
            return BizRegionRecreation.GetRegionRecreationById(regionRecreationId).Description;
        }

        public int GetRegionRecreationItemOrder (int regionRecreationId) {
            int? itemOrder = BizRegionRecreation.GetRegionRecreationById(regionRecreationId).ItemOrder;
            return itemOrder.HasValue ? itemOrder.Value : 0;
        }

        #endregion Dictionaries
    }

}
