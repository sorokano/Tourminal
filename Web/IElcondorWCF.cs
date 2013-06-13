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

namespace Elcondor {
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IElcondorWCF" in both code and config file together.
    [ServiceContract]
    public interface IElcondorWCF {
        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetWeatherInfo (string cityName);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetCountryGMTOffset (string countryName);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetLocaltime (double offset);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetCountryListJS ();

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetDistrictListJS (int countryId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetDistrictListWithArticlesByCountryIdJS (int countryId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetCountryListWithToursJS (int countryId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetCityListByCountryJS (int countryId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetCityListByDistrictJS (int RegionId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetSightseeingTypeListJS ();

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetRegionRecreationDescr (int regionRecreationId);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        int GetRegionRecreationItemOrder (int regionRecreationId);
    }
}
