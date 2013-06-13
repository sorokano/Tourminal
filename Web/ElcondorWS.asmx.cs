using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Threading;
using System.Text;
using LinqToElcondor;
using System.IO;
using System.Drawing;
using ElcondorBiz;
using Elcondor.Models;
using Elcondor.UI.Utilities;
using System.Web.Script.Serialization;
using System.Web.Script.Services;

namespace Elcondor {
    /// <summary>
    /// Summary description for TaratripWS
    /// </summary>
    [WebService(Namespace = "http://tourminal.ru/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [System.Web.Script.Services.ScriptService] 
    public class ElcondorWS : System.Web.Services.WebService {                      
        #region Dictionaries

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json, XmlSerializeString = false, UseHttpGet = true)]
        public string GetCountryListJS() {
            return BizDictionary.GetCountryListJS();
        }
        
        [WebMethod]
        public string GetDistrictListJS(int countryId) {
            return BizDictionary.GetDistrictListJS(countryId); ;
        }

        [WebMethod]
        public string GetCityListByCountryJS(int countryId) {
            return BizDictionary.GetCityListByCountryJS(countryId); ;
        }

        [WebMethod]
        public string GetCityListByDistrictJS(int RegionId) {
            return BizDictionary.GetCityListByDistrictJS(RegionId); ;
        }
        
        #endregion Dictionaries
    }
}
