using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Threading;
using TaratripLinq;
using System.IO;
using System.Drawing;
using TaratripBiz;
using Elcondor.Models;
using Elcondor.Utilities;
using Elcondor.UI.Utilities;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web;
using System.Web.Services;
using Microsoft.Ajax.Samples;

namespace Elcondor {
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "ITaratripWCF" in both code and config file together.
    [ServiceContract]
    public interface ITaratripWCF {
        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetCountryList();

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetHotelViewByIdHTML(string hotelId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetHotelPhotoCount(string hotelId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetHotelGalleryViewByIdHTML(string hotelId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetHotelImagesHTML(string hotelId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetHotelSearchResult(string formVars);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetCurrencyList();

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetDistrictList(int countryId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetCityListByCountry(int countryId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetCityListByDistrict(int districtId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetAccomodationTypeList();

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetHotelStatusList();

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetGoodForPersonList();
    }
}
